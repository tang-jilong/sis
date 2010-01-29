class ChartController < ApplicationController
  require 'gruff'
  layout "modal"
  
  
  def index
    @chart_title=[["往年奖金趋势图","generate_bar_chart"],
    ["往年工资组成图","generate_stacked_bar"],
    ["往年详细收入图","generate_line_chart"]]
    render :layout=>'menu' 
  end
  
#  员工奖金柱状图
  def generate_bar_chart
    user_name=session[:user_name]
    data_arry=Array.new
    for t in 1..12 
    if t<10
        fDate="2008-0#{t}"
        if t==9
          eDate="2008-#{t+1}"
        else
          eDate="2008-0#{t+1}"
        end
      else
        fDate="2008-#{t}"
        eDate="2008-#{t+1}"
    end
    
    @bonus_arry=SalaryInfo.find(:all,:conditions => ['name=? AND issue_date Between ? AND ?',user_name,fDate,eDate])
#    @bonus_arry=SalaryInfo.find(:all,:conditions => ['type_name ? AND issue_date Between ? AND ?','奖金',fDate,eDate])
    total=0
    if @bonus_arry!=nil&&@bonus_arry.size>0
      @bonus_arry.each do |temp|
          data=temp.data_info
          item=data.split("|")
         if item[4]!=nil&&item[4]!=''
          total=total+item[4].to_i
        else
          total=total+item[3].to_i
        end
      end
    end
    data_arry.push(total)
    t=t+1
    end
    
    @datasets = [
       [user_name,data_arry] 
    ]
    
   @labels = {
      0 => 'Jan', 
      1 => 'Feb', 
      2 => 'Mar', 
      3 => 'Apr', 
      4 => 'May', 
      5 => 'Jun', 
      6 => 'Jul', 
      7 => 'Aug',
      8 => 'Sep', 
      9 => 'Oct', 
      10 => 'Nov', 
      11 => 'Dec', 
    }  
         
    session[:method_name]="generate_bar_chart"
    b=Gruff::Bar.new("700x600")
    b.title = "Bonu Trend Diagram"
    b.title_margin = 100
    b.labels = @labels
    @datasets.each do |data|
      b.data(data[0], data[1])
    end
    b.write("bonus_trend.png")
    send_data(b.to_blob, :disposition => 'inline', :type => 'image/png', :filename => "bonus_trend.png")
  end  
  
  
  
  def generate_line_chart
    user_name=session[:user_name]
#    bonus 
    bon_arry=Array.new
    others_arry=Array.new
    sal_arry=Array.new
    ototal=0
    total=0
    
    for l in 1..12 
      puts l
      if l<10
          fDate="2008-0#{l}"
          if l==9
            eDate="2008-#{l+1}"
          else
            eDate="2008-0#{l+1}"
          end
        else
          fDate="2008-#{l}"
          eDate="2008-#{l+1}"
      end
    
    @bonus_arry=SalaryInfo.find(:all,:conditions => ['type_name= ? AND name=? AND issue_date Between ? AND ?','奖金',user_name,fDate,eDate])
#    @bonus_arry=SalaryInfo.find(:all,:conditions => ['type_name= ? AND issue_date Between ? AND ?','奖金',fDate,eDate])
    @o_arry=SalaryInfo.find(:all,:conditions => ['type_name= ? AND name=? AND issue_date Between ? AND ?','其它',user_name,fDate,eDate])
#    @o_arry=SalaryInfo.find(:all,:conditions => ['type_name ? AND issue_date Between ? AND ?','其它',fDate,eDate])
#    @s_arry=Salary.find_by_sql("select sum(final_num) as fnum from salaries where name = #{user_name} and issue_date between #{fDate} and #{eDate} group by name")
   @s_arry=Salary.find(:all,:select=>['sum(final_num) as fnum'],:conditions=>['name=? AND issue_date Between ? AND ?', user_name, fDate ,eDate])
    if @s_arry!=nil
      sal_arry.push(@s_arry.fetch(0).fnum.to_i)
    end
    
    if @bonus_arry!=nil&&@bonus_arry.size>0
      @bonus_arry.each do |temp|
          data=temp.data_info
          item=data.split("|")
          if item[4]!=nil
             total=total+item[4].to_i  
          else
            total=total+item[3].to_i  
            end
      end
    end
    bon_arry.push(total)
    
    if @o_arry!=nil&&@o_arry.size>0
      @o_arry.each do |temp|
          data=temp.data_info
          item=data.split("|")
          if item[4]!=nil
            ototal=ototal+item[4].to_i
          else
          ototal=ototal+item[3].to_i  
          end
      end
    end
    others_arry.push(ototal)
    l=l+1
  end
       
   @labels = {
    0 => 'Jan', 
    1 => 'Feb', 
    2 => 'Mar', 
    3 => 'Apr', 
    4 => 'May', 
    5 => 'Jun', 
    6 => 'Jul', 
    7 => 'Aug',
    8 => 'Sep', 
    9 => 'Oct', 
    10 => 'Nov', 
    11 => 'Dec', 
  }  
    
     @datasets = [
       [:Bonus,bon_arry],
       [:Salary,sal_arry],
       [:Others,others_arry]
    ]
    
    session[:method_name]="generate_line_chart"
    g = Gruff::Line.new("800x800") #Define a New Graph
    #    g.font= File.expand_path('#{RAILS_ROOT}/public/download_xls/ARIAL.TTF')  
    g.title = "My Salary Bonus&Others Compare Line Graph"    
    @datasets.each do |data|
      g.data(data[0], data[1])
    end
    g.write('detail_incoming.png')  
    send_data(g.to_blob, :disposition => 'inline', :type => 'image/png', :filename => "detail_incoming.png")
    #    send_data g.to_blob, :type => 'image/png'
    #    render :layout=>'modal' and return
  end
  
  
  def generate_pie_chart
    g = Gruff::Pie.new("600x600")
    user_name=session[:user_name]
    total_bonus_arry=Array.new
    total_salary_arry=Array.new
    total_others_arry=Array.new
#    get total salary 
#    @t_sal=Salary.find_by_sql("SELECT sum(final_num) as fnum FROM salaries where issue_date like '2008%' and name=#{user_name} group by name;")
    @t_sal=Salary.find(:all,:select=>['sum(final_num) as fnum'],:conditions=>['name=? AND issue_date Between ? AND ?', user_name, '2008-01-01' ,'2009-01-01'])
    total_salary=@t_sal.fetch(0).fnum
    total_salary_arry.push(total_salary)
#    get total bonus
    @t_bonus=SalaryInfo.find(:all,:conditions => ['issue_date > ? and name=? and type_name=?','2008-01-01',user_name,'奖金'])
    total_bonus=0
    if @t_bonus!=nil&&@t_bonus.size>0
      @t_bonus.each do |bon|
        data=bon.data_info
        item=data.split("|")
        if item[4]!=nil
        total_bonus=total_bonus+item[4].to_i  
       else
          total_bonus=total_bonus+item[3].to_i
        end
      end  
  end
  total_bonus_arry.push(total_bonus)

#    get total others 
    @t_others=SalaryInfo.find(:all,:conditions => ['issue_date > ? AND name=? AND type_name=?','2008-01-01',user_name,'其它'])
    total_others=0
    if @t_others!=nil&&@t_others.size>0
      @t_others.each do |bon|
        data=bon.data_info
        item=data.split("|")
        total_others=total_others+item[3].to_i  
      end  
    end
    total_others_arry.push(total_others)
    
    @datasets = [[:Bonus, total_bonus_arry],
                        [:Salary, total_salary_arry],
                        [:Others, total_others_arry]]

    session[:method_name]="generate_pie_chart"
    g.title = "My Incoming Pie Graph"
    g.title_margin = 100
    #    g.theme_pastel
    @datasets.each do |data|
      g.data(data[0], data[1])
    end
    g.write("combination_diagram.png")
    send_data(g.to_blob, :disposition => 'inline', :type => 'image/png', :filename => "combination_diagram.png")
  end
  
  def generate_stacked_bar
    user_name=session[:user_name]
    bon_arry=Array.new
    others_arry=Array.new
    sal_arry=Array.new
    ototal=0
    total=0
    
    for l in 1..12 
      if l<10
          fDate="2008-0#{l}"
          if l==9
            eDate="2008-#{l+1}"
          else
            eDate="2008-0#{l+1}"
          end
        else
          fDate="2008-#{l}"
          eDate="2008-#{l+1}"
      end
    
    @bonus_arry=SalaryInfo.find(:all,:conditions => ['type_name= ? AND name=? AND issue_date Between ? AND ?','奖金',user_name,fDate,eDate])
#    @bonus_arry=SalaryInfo.find(:all,:conditions => ['type_name= ? AND issue_date Between ? AND ?','奖金',fDate,eDate])
    @o_arry=SalaryInfo.find(:all,:conditions => ['type_name= ? AND name=? AND issue_date Between ? AND ?','其它',user_name,fDate,eDate])
#    @o_arry=SalaryInfo.find(:all,:conditions => ['type_name ? AND issue_date Between ? AND ?','其它',fDate,eDate])
#    @s_arry=Salary.find_by_sql("select sum(final_num) as fnum from salaries where name = #{user_name} and issue_date between #{fDate} and #{eDate} group by name")
   @s_arry=Salary.find(:all,:select=>['sum(final_num) as fnum'],:conditions=>['name=? AND issue_date Between ? AND ?', user_name, fDate ,eDate])
    if @s_arry!=nil
      sal_arry.push(@s_arry.fetch(0).fnum.to_i)
    end
    
    if @bonus_arry!=nil&&@bonus_arry.size>0
      @bonus_arry.each do |temp|
          data=temp.data_info
          item=data.split("|")
          if item[4]!=nil
             total=total+item[4].to_i  
          else
            total=total+item[3].to_i  
            end
      end
    end
    bon_arry.push(total)
    
    if @o_arry!=nil&&@o_arry.size>0
      @o_arry.each do |temp|
          data=temp.data_info
          item=data.split("|")
          if item[4]!=nil
            ototal=ototal+item[4].to_i
          else
          ototal=ototal+item[3].to_i  
          end
      end
    end
    others_arry.push(ototal)
    l=l+1
  end
       
   @labels = {
    0 => 'Jan', 
    1 => 'Feb', 
    2 => 'Mar', 
    3 => 'Apr', 
    4 => 'May', 
    5 => 'Jun', 
    6 => 'Jul', 
    7 => 'Aug',
    8 => 'Sep', 
    9 => 'Oct', 
    10 => 'Nov', 
    11 => 'Dec', 
  }  
    
     @datasets = [
       [:Bonus,bon_arry],
       [:Salary,sal_arry],
       [:Others,others_arry]
    ]
      
    
      
    g = Gruff::StackedBar.new
     g.labels= @labels
    g.title = "Visual Stacked Bar Graph Test"
    @datasets.each do |data|
      g.data(data[0], data[1])
    end
    session[:method_name]='generate_stacked_bar'
    g.write("stacked_diagram.png")
    send_data(g.to_blob, :disposition => 'inline', :type => 'image/png', :filename => "stacked_diagram.png")
  end
  
end
