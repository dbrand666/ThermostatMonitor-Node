DateFormatter = require ("./date-formatter.coffee")
sys = require("sys")

class Utils
	@generateGuid: () ->
		return Utils.s4() + Utils.s4() + '-' + Utils.s4() + '-' + Utils.s4() + '-' + Utils.s4() + '-' + Utils.s4() + Utils.s4() + Utils.s4()
	@s4: () ->
		return Math.floor((1 + Math.random()) * 0x10000).toString(16).substring(1).toUpperCase()
	@key: () ->
		new Date().getTime().toString(36)
	@getDisplayDate: (date, format) ->
		format = "m/d/yyyy" if not format?
		result = ""
		result = DateFormatter.format date, format if date? and date!=null
		return result
	@getCsv: (headers, data) ->
		first = true
		output = ''
		headers.forEach (header) ->
			output += ',' if not first
			output += '"' + header + '"'
			first = false
		output += '\r\n'
		data.forEach (row) ->
			first = true
			row.forEach (cell) ->
				output += ',' if not first
				output += cell.toString() if cell?
				first = false
			output += '\r\n'
		return output
	@isDaylightSavings: () ->
		jan = new Date(new Date().getFullYear(), 0, 1)
		now = new Date()
		jan.getTimezoneOffset()!=now.getTimezoneOffset()
	@getAdjustedTimezone: (timezone, daylightSavings) ->
		timezone = timezone + 1 if daylightSavings and @isDaylightSavings()
		timezone
	@getServerDate: (userDate, timezone, daylightSavings) ->
		if not userDate.setHours?
			userDate = new Date(userDate)
		else
			userDate = new Date(userDate.getTime()) #copy the date so we don't change the original value
		timezone = @getAdjustedTimezone if daylightSavings?
		timezoneAdjustment = timezone + new Date().getTimezoneOffset() / 60
		userDate.setHours(userDate.getHours() - timezoneAdjustment) if timezoneAdjustment!=0
		userDate
	@getUserDate: (serverDate, timezone, daylightSavings) ->
		timezone = @getAdjustedTimezone if daylightSavings?
		timezoneAdjustment = new Date().getTimezoneOffset() / 60 + timezone
		serverDate.setHours(serverDate.getHours() + timezoneAdjustment)
		serverDate
	@getUtc: (date) ->
		date.setMinutes(date.getMinutes() + date.getTimezoneOffset())
		date
	@utcToServer: (date) ->
		date.setMinutes(date.getMinutes() - date.getTimezoneOffset())
		date
	@removeTime: (date) ->
		date.setMinutes(-date.getTimezoneOffset())
		date.setUTCHours(0)
		date.setUTCMinutes(0)
		date.setUTCSeconds(0)
		date.setUTCMilliseconds(0)
		date

module.exports = Utils