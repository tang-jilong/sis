class Menu < ActiveRecord::Base
  
  attr_accessor :selected
  attr_reader :topmenu, :sidemenu

  def initialize
    @sidemenu = Array.new
    @topmenu = Array.new
  end
  
  def find_top_menu role
   if role.role_name == "admin"||role.role_name == "行长"
       @topmenu= Menu.find(:all,:conditions=>['parent_id=0']);
     else role.role_name == "员工"
       @topmenu= Menu.find(:all,:conditions=>['parent_id=? and role_name=?',0,'员工'])
#       @sidemenu = Array.new
  end
end

  def find_sub_menu params, role
    if role.role_name=="员工"
    @sidemenu = Menu.find(:all,:conditions=>['parent_id=? and role_name=?',params,'员工'])
  elsif role.role_name=="主任"||role.role_name=="副主任"
    @sidemenu = Menu.find(:all,:conditions=>['parent_id=? and role_name=?',params,'主任'])
  elsif role.role_name=="admin"||role.role_name == "行长"
     @sidemenu = Menu.find(:all,:conditions=>['parent_id=?',params])
    end
  end
  
end
