describe User do
  let(:user) { create :user }

  it 'test' do
    expect(user.password).to eq 'wer432'
  end
end
