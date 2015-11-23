# DOC:
# We use Helper Methods for tree building,
# because it's faster than View Templates and Partials

# SECURITY note
# Prepare your data on server side for rendering
# or use h.html_escape(node.content)
# for escape potentially dangerous content
module RenderSortableTreeHelper
  module Render 
    class << self
      attr_accessor :h, :options

      def render_node(h, options)
        @h, @options = h, options
        node = options[:node]

        "
          <li data-node-id='#{ node.id }'>
            <div class='item'>
              <i class='handle'></i>
              #{ show_link }
              #{ controls }
            </div>
            #{ show_chores }
            #{ children }
          </li>
        "
      end

      def show_link
        node = options[:node]
        ns   = options[:namespace]
        url = h.url_for(:controller => options[:klass].pluralize, :action => :show, :id => node)
        title_field = options[:title]
        
        projects = options[:locals][:projects]
        current_project = projects.find(node)
        
        if current_project.thread_id
          "<h4>#{ h.link_to(node.send(title_field), url) } <b>unread emails!</b></h4>"
        else
          "<h4>#{ h.link_to(node.send(title_field), url) }</h4>"
        end
      #  if current_project.thread_id 
        
        #   "emails"
        #   "<%= image_tag('read_email.png', :alt => 'unread emails', :class => 'style_email_flag') %>" 
        # end
        
      end

      def controls
        node = options[:node]

        edit_path = h.url_for(:controller => options[:klass].pluralize, :action => :edit, :id => node)
       # archive_path = h.url_for(:controller => options[:klass].pluralize, :action => :archive, :id => node.id)
       archive_path = '/project/'+node.id.to_s+"/archive"

        "
          <div class='controls'>
            #{ h.link_to '', edit_path, :class => :edit }
            #{ h.link_to '', archive_path, :class => :delete, :method => :put, :data => { :confirm => 'Are you sure?' } }
          </div>
        "
      end
      
      def show_chores
        project_id = options[:node]
        chores = options[:locals][:chores]
        choretypes = options[:locals][:choretypes]
        current_chores = chores.where({project_id: project_id, archived: false}).order(:choretype_id)
        
        if !current_chores.empty?
          table="<table class='table-condensed'>"
          current_chores.each do |chore| 
            edit_path = h.url_for(:controller => :chores, :action => :edit, :id => chore.id)
            destroy_path = h.url_for(:controller => :chores, :action => :destroy, :id => chore.id)
            table+="<tr>"
            table+="<td> #{choretypes.find(chore.choretype_id).name}</td>"
            table+="<td>#{ h.link_to chore.title, edit_path}</td>"
            if chore.startdate
             table+="<td> #{chore.startdate.to_s(:due_date)}</td>"
            else
              table+="<td>-</td>"
            end
            if chore.deadline
             table+="<td> #{chore.deadline.to_s(:due_date)}</td>"
            else
              table+="<td>-</td>"
            end
            if (chore.schedule != {} and chore.schedule != nil)
             table+="<td> #{RecurringSelect.dirty_hash_to_rule(chore.schedule).to_s}</td>"
            else
              table+="<td>-</td>"
            end
            
            table+="<td> #{ h.link_to 'Delete', destroy_path, :method => :delete, :data => { :confirm => 'Are you sure?' } }</td>"

            table+="</tr>"
          end
         table+="</table>"
       end
       
        return table
      end

      def children
        unless options[:children].blank?
          "<ol class='nested_set'>#{ options[:children] }</ol>"
        end
      end

    end
  end
end
