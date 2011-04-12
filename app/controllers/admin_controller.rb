require 'pp'

class AdminController < ApplicationController
  navigation :administration
  before_filter :require_user

  def section_id
    'admin'
  end

  def index
  end

end

