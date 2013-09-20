#encoding=utf-8

class HomeController < ApplicationController
  before_filter :set_title
  
  def set_title
    @bread_crumbs = []
    @title = '首页'
  end
end
