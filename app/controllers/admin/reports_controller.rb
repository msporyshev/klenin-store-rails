require "socket"

class Admin::ReportsController < Admin::ApplicationController

  Report = Struct.new(:header, :body)

  def initialize
    super

    @report_fields = [
      ["User", :user],
      ["Category", :category],
      ["Purchase Year", :year],
      ["Purchase Month", :month],
      ["Purchase Day", :day]
    ]

    @report_value_types = [
      ["Total Quantity", :quantity],
      ["Total Price", :price],
      ["Both", :both]
    ]


  end

  def index

    respond_to do |format|

      format.html
      format.js
    end

  end

  include Socket::Constants

  def show
    @file_name = params[:id].to_s + ".pdf"
    unless File.exist?(Rails.root + "public/reports/" + @file_name)
      flash[:notice] = "This report is not ready yet. Try reload this page later."
      @file_name = nil
    end

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


end
