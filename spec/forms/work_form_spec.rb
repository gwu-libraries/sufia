require 'spec_helper'

describe CurationConcerns::GenericWorkForm do
  let(:form) { described_class.new(GenericWork.new, nil) }

  describe "#rendered_terms" do
    subject { form.rendered_terms }
    it { is_expected.not_to include(:visibilty, :visibility_during_embargo,
                                    :embargo_release_date, :visibility_after_embargo,
                                    :visibility_during_lease, :lease_expiration_date,
                                    :visibility_after_lease, :collection_ids) }
  end

  describe "#[]" do
    subject { form[term] }
    context "for collection_ids" do
      let(:term) { :collection_ids }
      it { is_expected.to eq [] }
    end
  end

  describe '.model_attributes' do
    let(:params) { ActionController::Parameters.new(
      title: ['foo'],
      description: [''],
      visibility: 'open',
      admin_set_id: '123',
      representative_id: '456',
      thumbnail_id: '789',
      tag: ['derp'],
      rights: ['http://creativecommons.org/licenses/by/3.0/us/'],
      collection_ids: ['123456', 'abcdef']) }

    subject { described_class.model_attributes(params) }

    it 'permits parameters' do
      expect(subject['title']).to eq ['foo']
      expect(subject['description']).to be_empty
      expect(subject['visibility']).to eq 'open'
      expect(subject['rights']).to eq ['http://creativecommons.org/licenses/by/3.0/us/']
      expect(subject['tag']).to eq ['derp']
      expect(subject['collection_ids']).to eq ['123456', 'abcdef']
    end

    context '.model_attributes' do
      let(:params) { ActionController::Parameters.new(
        title: [''],
        description: [''],
        tag: [''],
        rights: [''],
        collection_ids: ['']) }

      it 'removes blank parameters' do
        expect(subject['title']).to be_empty
        expect(subject['description']).to be_empty
        expect(subject['rights']).to be_empty
        expect(subject['tag']).to be_empty
        expect(subject['collection_ids']).to be_empty
      end
    end
  end
end
