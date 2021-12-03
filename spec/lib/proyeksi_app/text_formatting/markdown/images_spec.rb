#-- encoding: UTF-8



require 'spec_helper'

require_relative './expected_markdown'
describe ProyeksiApp::TextFormatting,
         'images' do
  include_context 'expected markdown modules'

  let(:options) { {} }

  context 'inline linking attachments' do
    context 'work package with attachments' do
      let!(:work_package) do
        FactoryBot.build_stubbed(:work_package).tap do |wp|
          allow(wp)
            .to receive(:attachments)
            .and_return attachments
        end
      end
      let(:attachments) { [inlinable, non_inlinable] }
      let!(:inlinable) do
        FactoryBot.build_stubbed(:attached_picture) do |a|
          allow(a)
            .to receive(:filename)
            .and_return('my-image.jpg')
          allow(a)
            .to receive(:description)
            .and_return('"foobar"')
        end
      end
      let!(:non_inlinable) do
        FactoryBot.build_stubbed(:attachment) do |a|
          allow(a)
            .to receive(:filename)
            .and_return('whatever.pdf')
        end
      end

      let(:only_path) { true }

      let(:options) { { object: work_package, only_path: only_path } }

      context 'for an inlineable attachment referenced by filename' do
        it_behaves_like 'format_text produces' do
          let(:raw) do
            <<~RAW
              ![](my-image.jpg)
            RAW
          end

          let(:expected) do
            <<~EXPECTED
              <p class="op-uc-p">
                <figure class="op-uc-figure">
                  <div class="op-uc-figure--content">
                    <img class="op-uc-image" src="/api/v3/attachments/#{inlinable.id}/content" alt='"foobar"'>
                  </div>
                </figure>
              </p>
            EXPECTED
          end
        end

        context 'with only_path false' do
          let(:only_path) { false }

          it_behaves_like 'format_text produces' do
            let(:raw) do
              <<~RAW
                ![](my-image.jpg)
              RAW
            end

            let(:expected) do
              <<~EXPECTED
                <p class="op-uc-p">
                  <figure class="op-uc-figure">
                    <div class="op-uc-figure--content">
                      <img class="op-uc-image" src="http://localhost:3000/api/v3/attachments/#{inlinable.id}/content" alt='"foobar"'>
                    </div>
                  </figure>
                </p>
              EXPECTED
            end
          end
        end
      end

      context 'for an inlineable attachment referenced by filename and alt-text' do
        it_behaves_like 'format_text produces' do
          let(:raw) do
            <<~RAW
              ![alt-text](my-image.jpg)
            RAW
          end

          let(:expected) do
            <<~EXPECTED
              <p class="op-uc-p">
                <figure class="op-uc-figure">
                  <div class="op-uc-figure--content">
                    <img class="op-uc-image" src="/api/v3/attachments/#{inlinable.id}/content" alt="alt-text">
                  </div>
                </figure>
              </p>
            EXPECTED
          end
        end
      end

      context 'for a non existing attachment and alt-text' do
        it_behaves_like 'format_text produces' do
          let(:raw) do
            <<~RAW
              ![foo](does-not-exist.jpg)
            RAW
          end

          let(:expected) do
            <<~EXPECTED
              <p class="op-uc-p">
                <figure class="op-uc-figure">
                  <div class="op-uc-figure--content">
                    <img class="op-uc-image" src="does-not-exist.jpg" alt="foo">
                  </div>
                </figure>
              </p>
            EXPECTED
          end
        end
      end

      context 'for a non inlineable attachment (non image)' do
        it_behaves_like 'format_text produces' do
          let(:raw) do
            <<~RAW
              ![](whatever.pdf)
            RAW
          end

          let(:expected) do
            <<~EXPECTED
              <p class="op-uc-p">
                <figure class="op-uc-figure">
                  <div class="op-uc-figure--content">
                    <img class="op-uc-image" src="whatever.pdf" alt="">
                  </div>
                </figure>
              </p>
            EXPECTED
          end
        end
      end

      context 'for a relative url (non attachment)' do
        it_behaves_like 'format_text produces' do
          let(:raw) do
            <<~RAW
              ![](some/path/to/my-image.jpg)
            RAW
          end

          let(:expected) do
            <<~EXPECTED
              <p class="op-uc-p">
                <figure class="op-uc-figure">
                  <div class="op-uc-figure--content">
                    <img class="op-uc-image" src="some/path/to/my-image.jpg" alt="">
                  </div>
                </figure>
              </p>
            EXPECTED
          end
        end
      end

      context 'for a relative url (non attachment)' do
        it_behaves_like 'format_text produces' do
          let(:raw) do
            <<~RAW
              ![](some/path/to/my-image.jpg)
            RAW
          end

          let(:expected) do
            <<~EXPECTED
              <p class="op-uc-p">
                <figure class="op-uc-figure">
                  <div class="op-uc-figure--content">
                    <img class="op-uc-image" src="some/path/to/my-image.jpg" alt="">
                  </div>
                </figure>
              </p>
            EXPECTED
          end
        end
      end
    end

    context 'escaping of malicious image urls' do
      it_behaves_like 'format_text produces' do
        let(:raw) do
          <<~RAW
            ![](/images/comment.png"onclick=&#x61;&#x6c;&#x65;&#x72;&#x74;&#x28;&#x27;&#x58;&#x53;&#x53;&#x27;&#x29;;&#x22;)
          RAW
        end

        let(:expected) do
          <<~EXPECTED
            <p class="op-uc-p">
              <figure class="op-uc-figure">
                <div class="op-uc-figure--content">
                  <img class="op-uc-image" src="/images/comment.png%22onclick=alert('XSS');%22" alt="">
                </div>
              </figure>
            </p>
          EXPECTED
        end
      end
    end
  end

  context 'via html tags' do
    it_behaves_like 'format_text produces' do
      let(:raw) do
        <<~RAW
          <figure class="image op-uc-figure" style="width:50%">
            <img src="/api/v3/attachments/1293/content">
            <figcaption>Some caption with meaning</figcaption>
          </figure>
        RAW
      end

      let(:expected) do
        <<~EXPECTED
          <figure class="image op-uc-figure" style="width:50%">
            <div class="op-uc-figure--content">
              <img src="/api/v3/attachments/1293/content" class="op-uc-image">
            </div>
            <figcaption class="op-uc-figure--description">Some caption with meaning</figcaption>
          </figure>
        EXPECTED
      end
    end
  end
end
