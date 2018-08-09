module Sellers::InvitationHelper
  def owner_name(version)
    if version.name.present?
      version.name
    else
      version.owners.first.email
    end
  end
end
