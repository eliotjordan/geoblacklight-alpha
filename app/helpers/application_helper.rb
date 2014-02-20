module ApplicationHelper


def layer_type_image(type)
	case type
	when "Polygon"
		image_tag('ogp/type_polygon.png')
	when "Line"
		image_tag('ogp/type_arc.png')
	when "Point"
		image_tag('ogp/type_arc.png')
	when "Raster"
		image_tag('ogp/type_raster.png')
	else
		""
	end
end

def layer_institution_image(institution)
	case institution
	when "Stanford"
		image_tag('ogp/src_stanford.png')
	when "Berkeley"
		image_tag('ogp/src_berkeley.png')
	when "Harvard"
		image_tag('ogp/src_harvard.png')
	when "MIT"
		image_tag('ogp/src_mit.png')
	else
		""
	end
end




end
