module EditorTabsHelper
  def extra_code_tab
    "<li role='presentation'> <a data-target='#visible-extra' aria-controls='visible-extra' role='tab' data-toggle='tab' class='editor-tab'>#{fa_icon 'code'} #{t 'activerecord.attributes.exercise.extra'}</a> </li>".html_safe
  end

  def console_tab(active: false)
    "<li role='presentation' class='#{'active' if active}'>
        <a data-target='#console' aria-controls='console' tabindex='0' role='tab' data-toggle='tab' class='editor-tab'>
          #{fa_icon 'terminal'}#{t :console }
        </a>
     </li>".html_safe
  end

  def messages_tab(exercise, organization = Organization.current)
    "<li id='messages-tab' role='presentation'>
        <a data-target='#messages' tabindex='0' aria-controls='console' role='tab' data-toggle='tab' class='editor-tab'>
          #{fa_icon 'comments-o'} #{t :messages }
        </a>
     </li>".html_safe if organization.raise_hand_enabled? && exercise.has_messages_for?(current_user)
  end
end
