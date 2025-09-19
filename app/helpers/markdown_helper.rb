module MarkdownHelper
  def markdown(text)
    return "" if text.blank?

    options = {
      fenced_code_blocks: true,
      no_intra_emphasis: true,
      autolink: true,
      tables: true,
      strikethrough: true,
      space_after_headers: true,
      superscript: true,
      underline: true,
      highlight: true,
      quote: true,
      footnotes: true,
      lax_spacing: true
    }

    renderer = CustomRenderer.new(
      hard_wrap: true,
      safe_links_only: true,
      escape_html: false,
      link_attributes: { target: "_blank", rel: "noopener" }
    )

    markdown = Redcarpet::Markdown.new(renderer, options)
    markdown.render(text).html_safe
  end

  class CustomRenderer < Redcarpet::Render::HTML
    def header(text, level)
      "<h#{level} class='markdown-h#{level}'>#{text}</h#{level}>"
    end

    def paragraph(text)
      "<p class='markdown-p'>#{text}</p>"
    end

    def block_code(code, language)
      language ||= "text"
      "<pre class='markdown-pre'><code class='language-#{language}'>#{code}</code></pre>"
    end

    def codespan(code)
      "<code class='markdown-code'>#{code}</code>"
    end

    def block_quote(quote)
      "<blockquote class='markdown-blockquote'>#{quote}</blockquote>"
    end

    def list(contents, list_type)
      tag = list_type == :ordered ? "ol" : "ul"
      "<#{tag} class='markdown-list'>#{contents}</#{tag}>"
    end

    def list_item(text, list_type)
      "<li class='markdown-list-item'>#{text}</li>"
    end

    def emphasis(text)
      "<em class='markdown-em'>#{text}</em>"
    end

    def double_emphasis(text)
      "<strong class='markdown-strong'>#{text}</strong>"
    end

    def strikethrough(text)
      "<del class='markdown-del'>#{text}</del>"
    end

    def underline(text)
      "<u class='markdown-u'>#{text}</u>"
    end

    def highlight(text)
      "<mark class='markdown-mark'>#{text}</mark>"
    end

    def hrule
      "<hr class='markdown-hr my-8 border-t border-gray-200'>"
    end
  end
end
