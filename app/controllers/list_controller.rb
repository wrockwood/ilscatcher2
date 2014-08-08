class ListController < ApplicationController

    def fetch
        list_id = params[:list_id].to_s
        bookbag_path = '/eg/opac/results?bookbag='
        mech_request = create_agent(bookbag_path + list_id + '&limit=50')
        page = mech_request[1].parser
        list_name = page.css(".result-bookbag-name").text
        list_description = page.css(".result-bookbag-description").text

        itemlist = page.css(".result_table_row").map do |item|
            {
                :title => item.at_css(".record_title").text.strip,
                :author => item.at_css(".record_author").text.strip,
                :record_id => item.at_css(".record_title").try(:attr, 'name').gsub!(/record_/, "")
            }
        end

        render :json => { :name => list_name, :description => list_description, :items => itemlist }
    end

    def view
        list = params[:list]
        response = Rails.cache.read(list)
        render :json => response
    end

end
