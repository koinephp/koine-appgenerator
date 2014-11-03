require 'rails_helper'

describe PagesController do
  describe "#home" do
    before do
      get :show, id: 'home'
    end
    it { should respond_with(:success)  }
    it { should render_template('home')  }
  end
end
