#-- encoding: UTF-8



module ProyeksiApp
  module AccessKeys
    unless const_defined?(:ACCESSKEYS)
      ACCESSKEYS = { preview: '1',
                     new_work_package: '2',
                     edit: '3',
                     quick_search: '4',
                     project_search: '5',
                     help: '6',
                     more_menu: '7',
                     details: '8',
                     new_project: '9' }.freeze
    end

    def self.key_for(action)
      ACCESSKEYS[action]
    end
  end
end
