class SearchController < ApplicationController

	def basic_search
		serach_url = '/eg/opac/results?'
		query = 'query=' + params[:q]
		mech_request = create_agent(serach_url + query)
		page = mech_request[1].parser
		results = page.css(".result_table_row").map do |item|
			{
				:title => item.at_css(".record_title").text.strip,
				:author => item.at_css('[@name="item_author"]').text.strip.try(:squeeze, " "),
				:availability => item.at_css(".result_count").try(:text).split('at')[0].try(:strip),
				:online => item.search('a').text_includes("Connect to this resource online").first.try(:attr, "href"),
				:record_id => item.at_css(".record_title").attr('name').sub!(/record_/, ""),
				:image => item.at_css(".result_table_pic").try(:attr, "src").try(:gsub, /^\//, "http://catalog.tadl.org/"),
				:abstract => item.at_css('[@name="bib_summary"]').try(:text).try(:strip).try(:squeeze, " "),
				:contents => item.at_css('[@name="bib_contents"]').try(:text).try(:strip).try(:squeeze, " "),
				:record_year => item.at_css(".record_year").try(:text),
				:format_icon => item.at_css(".result_table_title_cell img").try(:attr, "src").try(:gsub, /^\//, "http://catalog.tadl.org/")
			}
		end

		facet_list = page.css(".facet_box_temp").map do |item|
			group={}
			group['title'] = item.at_css('.header/.title').text.strip.try(:squeeze, " ")
			group['facets'] = item.css("div.facet_template:not(.facet_template_selected)").map do |facet|
				child_facet = {}
				child_facet['facet'] = facet.at_css('.facet').text.strip.try(:squeeze, " ")
				child_facet['links'] = facet.css('a').map do |link|
					child_facet_link = {}
					child_facet_link['link'] = link.attr('href').split('?')[1]
					child_facet_link
				end
				child_facet
			end
			group
		end








		render :json => facet_list
	end



end
