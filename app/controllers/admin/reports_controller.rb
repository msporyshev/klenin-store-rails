class Admin::ReportsController < ApplicationController

  Report = Struct.new(:first_header, :second_header, :body)

  def initialize
    super

    @set_headers_procs = {
      :user => lambda { |header_type| set_users_header_to_reports(header_type) },
      :total_price => lambda { |header_type| set_total_prices_header_to_reports(header_type) },
      :purchased_at => lambda { |header_type| set_dates_header_to_reports(header_type) },
      :category => lambda { |header_type| set_categories_header_to_reports(header_type) }
    }

    @report = Report.new([], [], {})

  end

  def show
    init_report(:category, :user)
  end

  private

    def set_users_header_to_reports(header_type)
      @raw_reports.each { |report|
        @report.__send__(header_type).
          push report[:user].to_s if !@used[header_type][report[:user].to_s]
        @used[header_type][report[:user].to_s] = true
      }
    end

    def set_total_prices_header_to_reports(header_type)
      @raw_reports.each { |report|
        if !@used[header_type][report[:total_price].to_s]
          @report.__send__(header_type).push report[:total_price].to_s
          @used[header_type][report[:user].to_s] = true
        end
      }
    end

    def set_dates_header_to_reports(header_type)
      @raw_reports.each { |report|
        if !@used[header_type][report[:purchased_at].to_s]
          @report.__send__(header_type).push report[:purchased_at].to_s
          @used[header_type][report[:purchased_at].to_s] = true
        end
      }
    end

    def set_categories_header_to_reports(header_type)
      @raw_reports.each do |report|
        report[:products].each do |product|
          if !@used[header_type][product[:category].to_s]
            @report.__send__(header_type).push product[:category].to_s
            @used[header_type][product[:category].to_s] = true
          end
        end
      end
    end

    def init_report_cell_values(header1, header2)
      first_coord = nil
      second_coord = nil
      @raw_reports.each do |report|
        cell = {};
        first_coord = report[header1].to_s
        second_coord = report[header2].to_s
        report.each do |key, val|
          if key != header1 and key != header2
            if val.is_a? Array
              val.each do |elem|
                cell[key] = {}
                elem.each { |k, v|
                  if k == header1
                    first_coord = v.to_s
                  elsif k == header2
                    second_coord = v.to_s
                  else
                    cell[key][k] = v
                  end
                }
              end
            else
              cell[key] = val
            end
          end
        end
        @report.body[first_coord][second_coord].push cell
      end
    end

    def init_report(first_coord = :users, second_coord = :categories)
      @raw_reports = Cart.get_report_info
      @used = {}
      @used[:first_header] = {}
      @used[:second_header] = {}
      @set_headers_procs[first_coord].call(:first_header)
      @set_headers_procs[second_coord].call(:second_header)
      @used = nil

      @report.first_header.each do |first|
        @report.body[first] = {}
        @report.second_header.each do |second|
          @report.body[first][second] = []
        end
      end

      init_report_cell_values(first_coord, second_coord)
    end

end
