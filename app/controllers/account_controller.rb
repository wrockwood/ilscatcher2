class AccountController < ApplicationController
  def login
  	request = login_action(params[:username], params[:password])
  	agent = request[0]
  	page = request[1]
  	token = agent.cookies.detect {|c| c.name == 'ses'}
  	full_name = page.parser.css('span#dash_user').try(:text).strip
  	checkouts = page.parser.css('span#dash_checked').try(:text).strip
  	holds = page.parser.css('span#dash_holds').try(:text).strip
  	holds_ready = page.parser.css('span#dash_pickup').try(:text).strip
  	fines = page.parser.css('span#dash_fines').try(:text).strip
  	if token == nil
  		render :json =>{:message => 'login failed'}
  	else
  		render :json =>{:full_name => full_name, 
  			:checkouts => checkouts, 
  			:holds => holds,
  			:holds_ready => holds_ready,
  			:fine => fines, 
  			:token => token.value
  		}
  	end
  end

  def place_hold
  	record_ids = params[:record_ids].split(',').reject(&:empty?).map(&:strip).map {|k| "&hold_target=#{k}" }.join

  	if params[:token] == nil
  		render :json =>{:message => "you are not logged in"}
  		return
  	end


  	request = create_agent('/eg/opac/place_hold?hold_type=T' + record_ids,'', params[:token])
  	agent = request[0]
  	page = request[1].parser
  	page_title = page.title

  	if page_title == 'Catalog - Account Login'
  		render :json =>{:message => 'Invalid token'}
  		return
  	end
  	
  	hold_form = agent.page.forms[1]
  	submitt_holds = agent.submit(hold_form)
  	confirmation_messages = submitt_holds.parser.css('//table#hold-items-list//tr').map do |m|
  		{
  			:record_id => m.at_css("td[1]//input").try(:attr, "value"),
  			:message => m.at_css("td[2]").try(:text).try(:gsub!, /\n/," ").try(:squeeze, " ").try(:strip).try(:split, ". ").try(:last),
  		}
  	end

  	render :json =>{:confirmation_messages => confirmation_messages}
  end

  def renew_items
  	record_ids = params[:record_ids].split(',').reject(&:empty?).map(&:strip).map {|k| "&circ=#{k}" }.join

  	if params[:token] == nil
  		render :json =>{:message => "you are not logged in"}
  		return
  	end

  	request = create_agent('/eg/opac/myopac/circs?api=true' + record_ids,'', params[:token])
  	agent = request[0]
  	page = request[1].parser
  	page_title = page.title

  	if page_title == 'Catalog - Account Login'
  		render :json =>{:message => 'Invalid token'}
  		return
  	end

  	confirmation_messages = page.css('table#acct_checked_main_header').css('tr').map do |checkout|
        {
        	:name => checkout.at_css("/td[2]").try(:text).try(:strip).try(:gsub!, /\n/," ").try(:squeeze, " "),
        	:renew_attempts => checkout.css("/td[4]").text.to_s.try(:gsub!, /\n/," ").try(:squeeze, " ").try(:strip),
        	:due_date => checkout.css("/td[5]").text.to_s.try(:gsub!, /\n/," ").try(:squeeze, " ").try(:strip),
        	:checkout_id => checkout.at('td[1]/input').try(:value),
        	:barcode => checkout.css("/td[6]").text.to_s.try(:gsub!, /\n/," ").try(:squeeze, " ").try(:strip),
        }
    end
    render :json =>{:checkouts => confirmation_messages}

  end



end
