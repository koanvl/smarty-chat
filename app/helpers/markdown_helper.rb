module MarkdownHelper
  def markdown(text)
    return "" if text.blank?

    options = {
      fenced_code_blocks: true,
      no_intra_emphasis: true,
      autolink: true,
      tables: true
    }

    renderer = Redcarpet::Render::HTML.new(
      hard_wrap: true,
      safe_links_only: true
    )

    markdown = Redcarpet::Markdown.new(renderer, options)
    markdown.render(text).html_safe
  end
end
