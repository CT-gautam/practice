require 'rubygems'
require 'mechanize'
require 'mongo'

URL = 'http://220.225.213.209/corp/'
agent = Mechanize.new

page = agent.get(URL+'defaulterdet.asp')

html1 = Nokogiri::HTML(page.content)

z_val = html1.xpath("//select[@name = 'cmbZone']/option")[1..-1]

z_val.each do |z|
	zone = agent.get(URL+"getWard.asp?q=#{z.xpath('@value')}&ward=undefined")
	html2 = Nokogiri::HTML(zone.content)
	w_val = html2.xpath("//select[@name = 'cmbWard']/option")[1..-1]

	w_val.each do |w|

		param = Hash.new
		param['cmbZone'] = z.xpath('@value')
		param['cmbWard'] = w.xpath('@value')
		param['clientUrl']='defaulterdet'
		submit = agent.post(URL+'defaulterdet.asp',param).content

		html3 = Nokogiri::HTML(submit)

		header = []
		head = html3.xpath("//th")
		head.each do |hd|
			header.push(hd.text)
		end
		
		(0...10).each do |i|
			header[i] = header[i].downcase
			header[i] = header[i].rstrip
			header[i] = header[i].gsub(".","_")
			header[i] = header[i].gsub(" ","_")
		end

		records=[]
		rec = html3.css("div#result").css('td')
		rec.each do |record|
			records.push(record.text)
		end

		all_cases=[]
		(0...records.size).step(10).each do |i|
			h = Hash.new
			(0...10).each do |j|
				h[header[j]] = records[i+j]
			end
			h.delete(header[2])
			all_cases.push(h)
		end

		document = Hash.new
		document['zone'] = z.text#/[A-Z]*/.match(z.text).to_s
		document['ward_no'] = w.xpath('@value').text
		document['count_all'] = records.size/10
		document['all_cases'] = all_cases

		puts "#{document['zone']}" + '='*10 + "#{document['ward_no']}"
		puts '='*100

		# db = Mongo::Client.new("localhost", :database => 'assignment')
		# coll.insert(document)

		Mongo::Logger.logger.level = ::Logger::FATAL

		client = Mongo::Client.new("localhost")
		db = client.use("assignment")
		db.defaulter.insert(document)

		break
	end
	break
end
db.close