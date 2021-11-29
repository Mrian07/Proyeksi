#-- encoding: UTF-8



require 'spec_helper'

describe ToolbarHelper, type: :helper do
  describe '.toolbar' do
    it 'should create a default toolbar' do
      result = toolbar title: 'Title'
      expect(result).to be_html_eql %{
        <div class="toolbar-container">
          <div class="toolbar">
            <div class="title-container">
              <h2>Title</h2>
            </div>
            <ul class="toolbar-items"></ul>
          </div>
        </div>
      }
    end

    it 'should be able to add a subtitle' do
      result = toolbar title: 'Title', subtitle: 'lorem'
      expect(result).to be_html_eql %{
        <div class="toolbar-container">
          <div class="toolbar">
            <div class="title-container">
              <h2>Title</h2>
            </div>
            <ul class="toolbar-items"></ul>
          </div>
          <p class="subtitle">lorem</p>
        </div>
      }
    end

    it 'should be able to add a link_to' do
      result = toolbar title: 'Title', link_to: link_to('foobar', user_path('1234'))
      expect(result).to be_html_eql %{
        <div class="toolbar-container">
          <div class="toolbar">
            <div class="title-container">
              <h2>Title: <a href="/users/1234">foobar</a></h2>
            </div>
            <ul class="toolbar-items"></ul>
          </div>
        </div>
      }
    end

    it 'should escape the title' do
      result = toolbar title: '</h2><script>alert("foobar!");</script>'
      expect(result).to be_html_eql %{
        <div class="toolbar-container">
          <div class="toolbar">
            <div class="title-container">
              <h2>&lt;/h2&gt;&lt;script&gt;alert(&quot;foobar!&quot;);&lt;/script&gt;</h2>
            </div>
            <ul class="toolbar-items"></ul>
          </div>
        </div>
      }
    end

    it 'should include capsulate html' do
      result = toolbar title: 'Title' do
        content_tag :li do
          content_tag :p, 'paragraph', data: { number: 2 }
        end
      end
      expect(result).to be_html_eql %{
        <div class="toolbar-container">
          <div class="toolbar">
            <div class="title-container">
              <h2>Title</h2>
            </div>
            <ul class="toolbar-items">
              <li>
                <p data-number="2">paragraph</p>
              </li>
            </ul>
          </div>
        </div>
      }
    end
  end
  describe '.breadcrumb_toolbar' do
    it 'should escape properly' do
      result = breadcrumb_toolbar '</h2><script>alert("foobar!");</script>',
                                  link_to('foobar', user_path('1234'))

      expect(result).to be_html_eql %{
        <div class="toolbar-container">
          <div class="toolbar">
            <div class="title-container">
              <h2>&lt;/h2&gt;&lt;script&gt;alert(&quot;foobar!&quot;);&lt;/script&gt; &raquo; <a href="/users/1234">foobar</a></h2>
            </div>
            <ul class="toolbar-items"></ul>
          </div>
        </div>
      }
    end
  end
end
