#Make the json datetime a format that candlepin can understand
class DateTime
    def as_json(options = nil)
        strftime('%Y-%m-%dT%H:%M:%S')
    end
end
