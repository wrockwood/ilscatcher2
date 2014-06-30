class ApplicationController < ActionController::API
require 'mechanize'



def create_agent(url = '', post_params = '', token = '')
	opac_base_url = 'https://eg.dev.tadl.org'
	# NOTE NEED to remove SSL VERIFY NONE in production
	agent = Mechanize.new{|a| a.ssl_version, a.verify_mode = 'SSLv3', OpenSSL::SSL::VERIFY_NONE}
	full_url = opac_base_url + url
	if token != ''
		cookie = Mechanize::Cookie.new('ses', token)
		cookie.domain = opac_base_url
		cookie.path = "/"
		agent.cookie_jar.add!(cookie)
	end	
    if url != ''
       if post_params != ''
            page = agent.post(full_url, post_params) rescue page = Mechanize::Page.new(uri = nil, response = nil, body = nil, code = '500', mech = nil)
            return agent, page
       else
            page = agent.get(full_url) rescue page = Mechanize::Page.new(uri = nil, response = nil, body = nil, code = '500', mech = nil)
            return agent, page
       end
    else
            return agent
    end
end

def login_action(username, password)
    agent = Mechanize.new
    page = agent.get(opac_base_url + '/eg/opac/login?redirect_to=%2Feg%2Fopac%2Fmyopac%2Fmain')
    form = agent.page.forms[1]
    form.field_with(:name => "username").value = username
    form.field_with(:name => "password").value = password
    form.checkbox_with(:name => "persist").check
    agent.submit(form)
    return agent
end



end
