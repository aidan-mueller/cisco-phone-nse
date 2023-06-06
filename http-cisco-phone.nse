local http = require "http"
local pcre = require "pcre"
local stdnse = require "stdnse"
local string = require "string"

description = [[
Gets the model, extension, and MAC of Cisco IP phones.

The script will follow up to 5 HTTP redirects, using the default rules in the http library.
]]

--@output
-- Nmap scan report for localhost (127.0.0.1)
-- PORT    STATE SERVICE
-- 80/tcp  open  http
-- | http-cisco-phone: 
-- |   MAC: A0B1C2D3E4F5
-- |   extension: 172839
-- |_  model: CP-8811

author = "Aidan Mueller"

license = "Simplified (2-clause) BSD license--See https://nmap.org/svn/docs/licenses/BSD-simplified"

categories = {"default", "discovery", "safe"}

prop_reg_map = {
	extension = {"Phone DN", "([0-9]{6})"},
	MAC = {"MAC Address", "([A-F0-9]{12})"},
	model = {"Model Number", "(CP-[0-9]+)"}
}

portrule = function(host, port)
	return port.number == 80 and (port.state == "open" or port == nil)
end

action = function(host, port)
	local resp
	
	resp = http.get(host, 80, "/")

	if ( not(resp.body) ) then
		return
	end
	
	body_txt = string.gsub(resp.body, "&#x2D;", "-")
	
	local output_tab = stdnse.output_table()
	
	local td_open_rx = pcre.new("<td>", 1, "C")
	
	for property, rx_pair in pairs(prop_reg_map) do
		local attr_rx = pcre.new(rx_pair[1], 1, "C")
		local s, e = attr_rx:match(body_txt, 0, 0)
		
		s, e = td_open_rx:match(body_txt, e + 1, 0)
		
		local value_rx = pcre.new(rx_pair[2], 1, "C")
		s, e, matches = value_rx:match(body_txt, e + 1, 0)
		
		if s ~= nil then
			output_tab[property] = matches[1]
		end
	end

	return output_tab
end
