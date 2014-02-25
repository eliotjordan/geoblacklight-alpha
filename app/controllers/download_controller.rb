require 'nokogiri'
require 'httparty'
require 'net/http'

class Layer
  include HTTParty
  format :json

  def self.getInfo(params)
  	url = params['URL']
  	params['BBOX'] = formatLatLng(params['BBOX'])
  	puts params
    get(url, :query => params.except('URL'))
  end
end

# http://sds1.itc.virginia.edu:8080/thdl-geoserver/wfs?typename=thdl%3Atest2&layers=thdl%3Atest2&projection=EPSG%3A4326&service=wfs&version=1.0.0&request=GetFeature&srs=EPSG%3A4326&outputformat=shape-zip&cql_filter=[cql]

class DownloadController < ApplicationController
	def file
		
		send_file "tmp/data/#{params['q']}", :type=>"application/zip", :x_sendfile=>true 

	end

  def shapefile
  	location = JSON.parse(params['Location'])
  	
  	#checks for different types of wfs/wms configurations
  	if location['wfs'].kind_of?(Array)
  		wfsuri = location['wfs'][0]
		else
			wfsuri = location['wfs']
		end

		puts session['session_id']
		# if location['wms'].kind_of?(Array)
  # 		wmsuri = location['wms'][0]
		# else
		# 	wmsuri = location['wms']
		# end

		layerName = params['WorkspaceName'] + ":" + params['Name']


		# dparams = {:service => 'WMS', :version => '1.1.1', :request => 'DescribeLayer', :layers => layerName}
		# info = HTTParty.get(wmsuri, :query => dparams)
		# puts info.parsed_response

  	params = {:service => 'wfs', :version => '2.0.0', :request => 'GetFeature', :srsName => 'EPSG:4326', :outputformat => 'SHAPE-ZIP', :typeName => layerName}
  	
		token = SecureRandom.base64(8).tr('+/=lIO0', 'abc123')
		error = ''

		# outuri = URI(wfsuri)
		# outuri.query = URI.encode_www_form(params)
		# puts outuri


		if !Dir.exists?('tmp/data')
			Dir.mkdir('tmp/data')
		end
		File.open("tmp/data/#{token}-shapefile.zip", 'wb')	do |f|
				puts "#{token}-shapefile.zip created"
				# f.write 
				dl = HTTParty.get(wfsuri, :query => params)
				# puts dl.inspect
				if dl.headers['content-type'] == 'application/zip'
					f.write dl.parsed_response
				else
					error = dl.parsed_response
				end
		end
  	respond_to do |format|
  		if error.length > 0
 				puts 'error!'
  			format.json { render :json => {:error => error}}
  			File.delete("tmp/data/#{token}-shapefile.zip")
  			puts "#{token}-shapefile.zip deleted"
  		else
  			format.json { render :json => {:data => "#{token}-shapefile.zip"}}
			end
		end

  end

  def kml

  	location = JSON.parse(params['Location'])
  	
  	#checks for different types of wfs/wms configurations
  	if location['wms'].kind_of?(Array)
  		wmsuri = location['wms'][0]
		else
			wmsuri = location['wms']
		end
		# http://geowebservices-restricted.stanford.edu/geoserver/druid/wms?service=WMS&version=1.1.0&request=GetMap&layers=druid:vv853br8653&styles=&bbox=-180.0,24.231259875615,180.0,73.9908661530771&width=2387&height=330&srs=EPSG:4326&format=application/vnd.google-earth.kmz

		layerName = params['WorkspaceName'] + ":" + params['Name']
		bbox = [params['MinX'], params['MinY'], params['MaxX'], params['MaxY']]
		bbox = bbox.join(',')

  	params = {:service => 'wms', :version => '1.1.0', :request => 'GetMap', :srsName => 'EPSG:4326', :format => 'application/vnd.google-earth.kmz', :layers => layerName, :bbox => bbox, :width => 2000, :height => 2000}
  	
		token = SecureRandom.base64(8).tr('+/=lIO0', 'abc123')
		error = ''

		if !Dir.exists?('tmp/data')
			Dir.mkdir('tmp/data')
		end
		File.open("tmp/data/#{token}.kmz", 'wb')	do |f|
				puts "#{token}.kmz created"
				# f.write 
				dl = HTTParty.get(wmsuri, :query => params)
				puts dl.headers.inspect
				if dl.headers['content-type'] == 'application/vnd.google-earth.kmz'
					f.write dl.parsed_response
				else
					error = dl.parsed_response
				end
		end
  	respond_to do |format|
  		if error.length > 0
 				puts 'error!'
  			format.json { render :json => {:error => error}}
  			File.delete("tmp/data/#{token}.kmz")
  			puts "#{token}.kmz deleted"
  		else
  			format.json { render :json => {:data => "#{token}.kmz"}}
			end
		end
  end
end
