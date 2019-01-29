module ApplicationHelper
  include WithStudentPathNavigation

  def profile_picture
    image_tag(current_user.image_url, height: 40, class: 'img-circle', onError: "this.onerror = null; this.src = '#{image_url('user_shape.png')}'")
  end

  def paginate(object, options={})
    "<div class=\"text-center\">#{super(object, {theme: 'twitter-bootstrap-3'}.merge(options))}</div>".html_safe
  end

  def last_box_class(trailing_boxes)
    trailing_boxes ? '' : 'mu-last-box'
  end

  def corollary_box(with_corollary, trailing_boxes = false)
    if with_corollary.corollary.present?
      %Q{
        <div class="#{last_box_class trailing_boxes}">
          <p>#{with_corollary.corollary_html}</p>
        </div>
      }.html_safe
    end
  end

  def chapter_finished(chapter)
    t :chapter_finished_html, chapter: link_to_path_element(chapter) if chapter
  end

  def span_toggle(hidden_text, active_text, active)
    %Q{
      <span class="#{'hidden' if active}">#{hidden_text}</span>
      <span class="#{'hidden' unless active}">#{active_text}</span>
    }.html_safe
  end
end

def sanitized(html)
  Mumukit::ContentType::Sanitizer.sanitize html
end
