#-- encoding: UTF-8



def aggregate_parent_array(example, acc)
  # We have to manually check parent groups for with_ee:,
  # since they are being ignored otherwise
  example.example_group.module_parents.each do |parent|
    if parent.respond_to?(:metadata) && parent.metadata[:with_ee]
      acc.merge(parent.metadata[:with_ee])
    end
  end

  acc
end

RSpec.configure do |config|
  config.before(:each) do |example|
    allowed = example.metadata[:with_ee]
    if allowed.present?
      allowed = aggregate_parent_array(example, allowed.to_set)

      allow(EnterpriseToken).to receive(:allows_to?).and_call_original
      allowed.each do |k|
        allow(EnterpriseToken)
          .to receive(:allows_to?)
          .with(k)
          .and_return true
      end

      # Also disable banners to signal the frontend we're on EE
      allow(EnterpriseToken).to receive(:show_banners?).and_return(allowed.empty?)
    end
  end
end
