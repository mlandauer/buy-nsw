module Products
  class UserSeparationForm < BaseForm
    property :virtualisation

    property :virtualisation_implementor
    property :virtualisation_third_party
    property :virtualisation_technologies
    property :virtualisation_technologies_other
    property :user_separation_details

    validation :default, inherit: true do
      required(:virtualisation).filled(:bool?)

      required(:virtualisation_implementor).maybe(
        in_list?: Product.virtualisation_implementor.values
      )
      required(:virtualisation_third_party).maybe(:str?)

      required(:virtualisation_technologies).maybe(
        one_of?: Product.virtualisation_technologies.values
      )
      required(:virtualisation_technologies_other).maybe(:str?)

      required(:user_separation_details).maybe(:str?, max_word_count?: 100)

      rule(virtualisation_implementor: [
        :virtualisation, :virtualisation_implementor,
      ]) do |radio, field|
        radio.true?.then(field.filled?)
      end
      rule(virtualisation_third_party: [
        :virtualisation, :virtualisation_implementor, :virtualisation_third_party,
      ]) do |radio, implementor, field|
        (radio.true? & implementor.eql?('third-party')).then(field.filled?)
      end

      rule(virtualisation_technologies: [
        :virtualisation, :virtualisation_technologies,
      ]) do |radio, field|
        radio.true?.then(field.filled?.any_checked?)
      end
      rule(virtualisation_technologies_other: [
        :virtualisation, :virtualisation_technologies, :virtualisation_technologies_other,
      ]) do |radio, checkboxes, field|
        (radio.true? & checkboxes.contains?('other')).then(field.filled?)
      end

      rule(user_separation_details: [:virtualisation, :user_separation_details]) do |radio, field|
        radio.true?.then(field.filled?)
      end
    end
  end
end
