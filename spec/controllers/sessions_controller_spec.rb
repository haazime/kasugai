require 'rails_helper'

describe SessionsController do
  describe '#create' do
    let(:user) { sign_up }

    context '未ログイン' do
      it do
        token = get_sign_in_token(user.email)
        session[:will_remove] = 123

        get :create, params: { token: token }

        aggregate_failures do
          expect(session[:user_id]).to_not eq(user.id)
          expect(session[:will_remove]).to be_nil
          expect(cookies.signed[:user_id]).to eq(user.id)
        end
      end

      it do
        token = get_sign_in_token(user.email)

        expect { get :create, params: { token: token } }
          .to change { RememberedUser.count }.by(1)
          .and change { RememberedUser.find_by(user_id: user.id).present? }.from(false).to(true)
      end
    end

    context 'ログイン済み' do
      it do
        sign_in(user)
        get :create, params: { token: 'dummy' }
        expect_already_signed_in
      end
    end
  end

  describe '#destroy' do
    let(:user) { sign_up }

    context '未ログイン' do
      it do
        delete :destroy
        expect_ensure_signed_in
      end
    end

    context 'ログイン済み' do
      before do
        sign_in(user)
      end

      it do
        delete :destroy

        aggregate_failures do
          expect(signed_in?).to be_falsey
          expect(cookies.signed[:user_id]).to be_nil
        end
      end

      it do
        expect { delete :destroy }
          .to change { RememberedUser.count }.by(-1)
          .and change { RememberedUser.find_by(user_id: user.id).present? }.from(true).to(false)
      end
    end
  end
end
