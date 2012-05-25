#!/usr/bin/env ruby

# Dump 'ohai' information in simple key/value pairs
#
# e.g.
#
# kernel.os=Darwin
# kernel.release=10.8.0
# kernel.version=Darwin Kernel Version 10.8.0: Tue Jun  7 16:32:41 PDT 2011; root:xnu-1504.15.3~1/RELEASE_X86_64
# uptime=49 days 01 hours 39 minutes 16 seconds
# languages.perl.version=5.12.4
#
# etc..


require 'ohai'

def e(data, ret=[], base="")

  if data.kind_of? Hash then
    data.keys.sort.each do |k|

      key = (base.empty?() ? "" : "#{base}.") + "#{k}"
      v = data[k]

      if v.kind_of? Hash then
        e(v, ret, key)

      elsif v.kind_of? Array then
        if v.first.kind_of? String then
          ret << "#{key}='" + v.join(",") + "'"
        else
          e(v, ret, key)
        end

      else
        ret << "#{key}=#{v}"
      end

    end # data.keys.sort.each

  elsif data.kind_of? Array then
    if data.first.kind_of? String then
      ret << "#{base}='" + data.join(",") + "'"
    else
      data.each do |v|
        e(v, ret, base)
      end
    end

  else
    ret << "#{base}=#{data}"

  end

  ret
end

ohai = Ohai::System.new
ohai.all_plugins
puts e(ohai.data)
