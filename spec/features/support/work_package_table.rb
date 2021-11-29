

shared_context 'work package table helpers' do
  def expect_work_packages_to_be_in_order(order)
    within_wp_table do
      preceeding_elements = order[0..-2]
      following_elements = order[1..-1]

      preceeding_elements.each_with_index do |wp_1, i|
        wp_2 = following_elements[i]
        expect(self).to have_selector(".wp-row-#{wp_1.id} + \
                                       .wp-row-#{wp_2.id}")
      end
    end
  end

  def within_wp_table(&block)
    within('.work-package-table--container', &block)
  end
end
