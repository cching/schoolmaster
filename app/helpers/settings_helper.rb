module SettingsHelper
  
  SORTS[:settings] = {}
  
  FIELDS[:settings] = {
    index: [:key, :value],
    show: { fields: [:key, :value], relations: [] },
    form: { fields: [:key, :value], relations: [] }
  }
  
end