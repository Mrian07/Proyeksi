#-- encoding: UTF-8



module HideSectionsHelper
  def initialize_hide_sections_with(all, active)
    gon.push(
      hide_sections: {
        all: all,
        active: active
      }
    )

    nonced_javascript_tag do
      include_gon(need_tag: false, nonce: content_security_policy_script_nonce, camel_case: true, camel_depth: 15)
    end
  end
end
