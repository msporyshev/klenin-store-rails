require "socket"

class Admin::ReportsController < ApplicationController

  Report = Struct.new(:header, :body)

  def initialize
    super

    @get_cell_value = {
      "quantity" => lambda { |report| get_quantity_cell_val(report) },
      "price" => lambda { |report| get_price_cell_val(report) },
      "both" => lambda { |report| get_quantity_and_price_cell_val(report) },
      "" => lambda { |report| [] }
    }

    @report_fields = [
      ["User", :user],
      ["Category", :category],
      ["Purchase Date", :purchased_at]
    ]

    @report_value_types = [
      ["Total Quantity", :quantity],
      ["Total Price", :price],
      ["Both", :both]
    ]

    @report = Report.new([[], []], {})

  end

  def index
    rows_field = !params[:rows_field].blank? ? params[:rows_field].to_sym : nil
    columns_field = !params[:columns_field].blank? ? params[:columns_field].to_sym : nil
    value_type = !params[:value_type].blank? ? params[:value_type].to_sym : nil

    init_report(rows_field, columns_field, value_type)

    respond_to do |format|

      format.html
      format.js
    end

  end

  include Socket::Constants

  def show
    @file_name = params[:id].to_s + ".pdf"

    respond_to do |format|
      format.html
    end
  end

  def download
    if params[:rows_field].blank? and params[:columns_field].blank? and params[:value_type].blank?
      redirect_to admin_reports_path
      return
    end

    rows_field = !params[:rows_field].blank? ? params[:rows_field].to_s : "NULL"
    columns_field = !params[:columns_field].blank? ? params[:columns_field].to_s : "NULL"
    value_type = !params[:value_type].blank? ? params[:value_type].to_s : "NULL"

    socket = Socket.new( AF_INET, SOCK_STREAM, 0 )
    sockaddr = Socket.pack_sockaddr_in( 30000, 'localhost' )
    socket.connect( sockaddr )

    socket.puts(rows_field)
    socket.puts(columns_field)
    socket.puts(value_type)
    socket.puts(params[:search].to_json)

    file_name = socket.gets
    file_name = File.basename(file_name.chomp, ".pdf")

    respond_to do |format|
      format.html { redirect_to admin_report_path(file_name) }
    end
  end

  private

    def set_header_to_report(header_type)
      @raw_reports.each { |report|
        if !@used[header_type][report[header_type].to_s]
          @report.header[header_type].push report[header_type].to_s
          @used[header_type][report[header_type].to_s] = true
        end
      }
    end

    COLUMNS_HEADER = 1
    ROWS_HEADER = 0

    def get_quantity_cell_val(report)
      [{:label => "Quantity", :value => report.last}]
    end

    def get_price_cell_val(report)
      [{:label => "Price", :value => report[-1]}]
    end

    def get_quantity_and_price_cell_val(report)
      [{:label => "Quantity", :value => report[-2]}, {:label => "Price", :value => report[-1]}]
    end

    def init_report(rows_field, columns_field, value_type)
      @used = []
      @used[COLUMNS_HEADER] = {}
      @used[ROWS_HEADER] = {}

      @raw_reports = Cart.get_report_info(rows_field, columns_field, value_type)

      set_header_to_report(ROWS_HEADER)
      if rows_field and columns_field
        set_header_to_report(COLUMNS_HEADER)
      else
        @report.header[COLUMNS_HEADER] << ""
        columns_value = ""
      end
      @used = nil

      @report.header[ROWS_HEADER].each do |first|
        @report.body[first] = {}
        @report.header[COLUMNS_HEADER].each do |second|
          @report.body[first][second] = []
        end
      end
      @raw_reports.each do |report|
        @report.body[report[ROWS_HEADER].to_s][columns_value || report[COLUMNS_HEADER].to_s] =
          @get_cell_value[value_type.to_s].call(report)
      end
    end

end
