class AjaxHelpController < ApplicationController

  PAGES = [:index, :tour, :accounts, :searching, :uploading, :troubleshooting, :notes, :collaboration, :privacy, :publishing, :public]
  PAGE_TITLES = {
    :index => 'Introduction',
    :tour => 'Guided Tour',
    :accounts => 'Adding Accounts',
    :searching => 'Searching Documents',
    :uploading => 'Uploading Documents',
    :troubleshooting => 'Troubleshooting Failed Uploads',
    :privacy => 'Privacy',
    :collaboration => 'Collaboration',
    :notes => 'Editing Notes and Sections',
    :publishing => 'Publishing &amp; Embedding'
  }

  layout false

  before_filter :login_required, :only => [:contact_us]

  def contact_us
    LifecycleMailer.deliver_contact_us(current_account, params[:message])
    json nil
  end

  PAGES.each do |resource|
    class_eval "def #{resource}; markdown(:#{resource}); end"
  end

  private

  def markdown(resource)
    contents = File.read("#{Rails.root}/app/views/help/#{resource}.markdown")
    links_filename = "#{Rails.root}/app/views/help/links/#{resource}_ajax_links.markdown"
    links = File.exists?(links_filename) ? File.read(links_filename) : ""
    render :text => RDiscount.new(contents+links).to_html, :type => :html
  end

end
