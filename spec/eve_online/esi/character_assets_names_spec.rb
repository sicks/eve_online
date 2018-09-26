# frozen_string_literal: true

require 'spec_helper'

describe EveOnline::ESI::CharacterAssetsNames do
  let(:options) { { character_id: 12_345_678, item_ids: [1_001_215_602_246] } }

  subject { described_class.new(options) }

  specify { expect(subject).to be_a(EveOnline::ESI::Base) }

  specify { expect(described_class::API_ENDPOINT).to eq('https://esi.evetech.net/v1/characters/%<character_id>s/assets/names/?datasource=%<datasource>s') }

  describe '#initialize' do
    its(:token) { should eq(nil) }

    its(:parser) { should eq(JSON) }

    its(:_read_timeout) { should eq(60) }

    its(:_open_timeout) { should eq(60) }

    its(:datasource) { should eq('tranquility') }

    its(:character_id) { should eq(12_345_678) }

    its(:item_ids) { should eq([1_001_215_602_246]) }
  end

  describe '#assets_names' do
    let(:asset_name) { double }

    let(:response) do
      [
        {
          item_id: 1_001_215_602_246,
          name: 'HOLE'
        }
      ]
    end

    before do
      #
      # subject.response # => [{"item_id"=>1001215602246, "name"=>"HOLE"}]
      #
      expect(subject).to receive(:response).and_return(response)
    end

    before do
      #
      # EveOnline::ESI::Models::AssetName.new(response.first) # => asset_name
      #
      expect(EveOnline::ESI::Models::AssetName).to receive(:new).with(response.first).and_return(asset_name)
    end

    specify { expect(subject.assets_names).to eq([asset_name]) }

    specify { expect { subject.assets_names }.to change { subject.instance_variable_defined?(:@_memoized_assets_names) }.from(false).to(true) }
  end

  describe '#http_method' do
    specify { expect(subject.http_method).to eq('Post') }
  end

  describe '#payload' do
    let(:item_ids) { double }

    let(:options) { { character_id: 12_345_678, item_ids: item_ids } }

    before { expect(item_ids).to receive(:to_json) }

    specify { expect { subject.payload }.not_to raise_error }
  end

  describe '#scope' do
    specify { expect(subject.scope).to eq('esi-assets.read_assets.v1') }
  end

  describe '#url' do
    specify do
      expect(subject.url).to eq('https://esi.evetech.net/v1/characters/12345678/assets/names/?datasource=tranquility')
    end
  end
end
