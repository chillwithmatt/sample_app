require 'spec_helper'

describe "Static pages" do

  subject { page }

  shared_examples_for "all static pages" do
    it { should have_selector('h1', text: heading) }
    it { should have_title(full_title(page_title)) }
  end

  describe "Home page" do
    before { visit root_path }
    let(:heading) { 'Sample App' }
    let(:page_title) { '' }
    let(:user) { FactoryGirl.create(:user) }
    let(:another_user) { FactoryGirl.create(:user) }
   
    it_should_behave_like "all static pages"
    it { should_not have_title ('| Home') }

    describe "for signed-in users" do
      describe "the user's feed" do
        before do
          FactoryGirl.create(:micropost, user: user, content: "Lorem ipsum")
          FactoryGirl.create(:micropost, user: user, content: "Dolor sit amet")
          @micropost = FactoryGirl.create(:micropost, user: another_user, content: "Open sesame!")
          sign_in user
          visit root_path
        end

        it "should render the user's feed" do
          user.feed.each do |item|
            expect(page).to have_selector("li##{item.id}", text: item.content)
          end
        end

        it { should_not have_link("delete", href: micropost_path(@micropost)) }

        describe "display micropost count (2 posts)" do
          before do
            sign_in user
            visit root_path
          end
          
          it { should have_content("2 microposts") }
        end

        describe "display micropost count (1 post)" do
          before do
            sign_in another_user
            visit root_path
          end
          
          it { should have_content("1 micropost") }
        end

        describe "paginate the feed" do
          before do
            31.times { FactoryGirl.create(:micropost, user: user) }
            sign_in user
          end
          
          it { should have_selector('div.pagination') }
        end       
      end

      describe "follower/following counts" do
        let(:other_user) { FactoryGirl.create(:user) }
        before do
          sign_in user
          other_user.follow!(user)
          visit root_path
        end

        it { should have_link("0 following", href: following_user_path(user)) }
        it { should have_link("1 followers", href: followers_user_path(user)) }
      end
    end
  end

  describe "Help page" do
    before { visit help_path }
    let(:heading) { 'Help' }
    let(:page_title) { 'Help' }

    it_should_behave_like "all static pages"
  end

  describe "About page" do
    before { visit about_path }
    let(:heading) { 'About Us' }
    let(:page_title) { 'About Us' }
    
    it_should_behave_like "all static pages"
  end

  describe "Contact page" do
    before { visit contact_path }
    let(:heading) { 'Contact' }
    let(:page_title) { 'Contact' }

    it_should_behave_like "all static pages"
  end

  it "should have the right links on the layout" do
    visit root_path
    click_link "About"
    expect(page).to have_title(full_title('About Us'))
    click_link "Help"
    expect(page).to have_title(full_title('Help'))
    click_link "Contact"
    expect(page).to have_title(full_title('Contact'))
    click_link "Home"
    expect(page).to have_title(full_title(''))
    click_link "sample app"
    expect(page).to have_title(full_title(''))
  end
end








