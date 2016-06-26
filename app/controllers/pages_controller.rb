class PagesController < ApplicationController
  def home
    @interests = Interest.published
    @form = NewRecipientForm.new(params)
  end
end
