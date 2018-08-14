module Sellers
  class AcceptWaitingSellerForm < Reform::Form
    property :password, virtual: true
    property :password_confirmation, virtual: true
  end
end
