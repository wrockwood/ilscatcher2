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
end
