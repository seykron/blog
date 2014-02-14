# All files in the 'lib' directory will be loaded
# before nanoc starts compiling.
include Nanoc3::Helpers::Blogging
include Nanoc3::Helpers::Tagging
include Nanoc3::Helpers::Rendering
include Nanoc3::Helpers::LinkTo
include Nanoc3::Helpers::Breadcrumbs

module PostHelper
  def get_pretty_date(post)
    attribute_to_time(post[:created_at]).strftime('%B %-d, %Y')
  end
end

# License: MIT
# Version: 0.1

module Nanoc::Helpers
  module Breadcrumb
    def breadcrumb_for(page)
      @hist = ""
        @p = @page
        while(1)
          @hist = " » <a href=\"" + @p.path + "\">" + @p.title + "</a>" + @hist
          break if (@p.path == "/")
          @p = @p.parent
        end
      @hist

    end

  end

  module Story
    # Returns an unsorted list of articles, i.e. items where the `kind`
    # attribute is set to `"article"`.
    #
    # @return [Array] An array containing all articles
    def stories
      blk = lambda { @items.select { |item| item[:kind] == 'story' } }
      if @items.frozen?
        @story_items ||= blk.call
      else
        blk.call
      end
    end

    # Returns a sorted list of articles, i.e. items where the `kind`
    # attribute is set to `"article"`. Articles are sorted by descending
    # creation date, so newer articles appear before older articles.
    #
    # @return [Array] A sorted array containing all articles
    def sorted_stories
      blk = lambda do
        stories.sort_by { |a| attribute_to_time(a[:created_at]) }.reverse
      end

      if @items.frozen?
        @sorted_story_items ||= blk.call
      else
        blk.call
      end
    end
  end
end

def get_post_start(post)
  content = post.compiled_content
  if content =~ /\s<!-- more -->\s/
    content = content.partition('<!-- more -->').first +
    "<div class='read-more'><a href='#{post.path}'>Continuar leyendo &rsaquo;</a></div>"
  end
  return content
end

def list_pads
  content=`mysql -uetherpad -p3th3rp4d.$ -Detherpad -e 'select store.key from store'    | grep -Eo '^pad:[^:]+'    | sed -e 's/pad://'    | sort    | uniq -c    | sort -rn    | awk '{if ($1!="2") {print $2 }}'`
  return content
end

include PostHelper
include Nanoc::Helpers::Breadcrumb
include Nanoc::Helpers::Story
