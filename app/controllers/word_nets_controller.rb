
class WordNetsController < ApplicationController

  before_action :set_word_net, only: %i[ show edit update destroy ]

  # GET /word_nets or /word_nets.json
  def index
  end

  def search
    keyword = params[:search].to_s.downcase.strip
    lemma = WordNet::Lemma.find_all(keyword).first
    synnets = lemma.synsets.map{|x| x.gloss}
    render json: { success: true, data: synnets }
  rescue => e
    Rails.logger.info(e.inspect)
    render json: { success: false, data: { messsage: e.inspect } }
  end

  def hypernym
    keyword = params[:search].downcase
    lemma = WordNet::Lemma.find_all(keyword).first
    synnets = lemma.synsets
    index = params[:index]
    selected_synnet = synnets[index.to_i]
    expand_synnets = selected_synnet.expanded_first_hypernyms
    data = expand_synnets.map do |x|
      {
        gloss: x.gloss,
        word: x.word_counts.keys
      }
    end

    seleted_word = data[1][:word][0]
    prefix1 = params[:prefix1].to_s.downcase.strip
    prefix2 = params[:prefix2].to_s.downcase.strip
    prefix3 = params[:prefix3].to_s.downcase.strip
    prefix4 = params[:prefix4].to_s.downcase.strip
    prefix5 = params[:prefix5].to_s.downcase.strip
    prefix6 = params[:prefix6].to_s.downcase.strip

    onelook1 = search_onelook(seleted_word, prefix1)
    onelook2 = search_onelook(seleted_word, prefix2)
    onelook3 = search_onelook(seleted_word, prefix3)
    onelook4 = search_onelook(seleted_word, prefix4)
    onelook5 = search_onelook(seleted_word, prefix5)
    onelook6 = search_onelook(seleted_word, prefix6)

    onelook_res1 = onelook1.first(50).map{|x| { word: x["word"], syn: x["tags"].include?("syn").to_s} }
    onelook_res2 = onelook2.first(50).map{|x| { word: x["word"], syn: x["tags"].include?("syn").to_s} }
    onelook_res3 = onelook3.first(50).map{|x| { word: x["word"], syn: x["tags"].include?("syn").to_s} }
    onelook_res4 = onelook4.first(50).map{|x| { word: x["word"], syn: x["tags"].include?("syn").to_s} }
    onelook_res5 = onelook5.first(50).map{|x| { word: x["word"], syn: x["tags"].include?("syn").to_s} }
    onelook_res6 = onelook6.first(50).map{|x| { word: x["word"], syn: x["tags"].include?("syn").to_s} }

    onelook_res1.shift()
    onelook_res2.shift()
    onelook_res3.shift()
    onelook_res4.shift()
    onelook_res5.shift()
    onelook_res6.shift()

    render json: { success: true, data: {
      expand_synnets: data,
      seleted_word: seleted_word,
      onelook_res1: onelook_res1,
      onelook_res2: onelook_res2,
      onelook_res3: onelook_res3,
      onelook_res4: onelook_res4,
      onelook_res5: onelook_res5,
      onelook_res6: onelook_res6,
      index: index,
      prefix1: prefix1,
      prefix2: prefix2,
      prefix3: prefix3,
      prefix4: prefix4,
      prefix5: prefix5,
      prefix6: prefix6

    }}
    # concatenated_string = "['purpose of' #{seleted_word}]"

  rescue => e
    Rails.logger.info(e.inspect)
    render json: { success: false, data: { messsage: e.inspect } }
  end

  # GET /word_nets/1 or /word_nets/1.json
  def show
  end

  # GET /word_nets/new
  def new
    @word_net = WordNet.new
  end

  # GET /word_nets/1/edit
  def edit
  end

  # POST /word_nets or /word_nets.json
  def create
    @word_net = WordNet.new(word_net_params)

    respond_to do |format|
      if @word_net.save
        format.html { redirect_to word_net_url(@word_net), notice: "Word net was successfully created." }
        format.json { render :show, status: :created, location: @word_net }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @word_net.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /word_nets/1 or /word_nets/1.json
  def update
    respond_to do |format|
      if @word_net.update(word_net_params)
        format.html { redirect_to word_net_url(@word_net), notice: "Word net was successfully updated." }
        format.json { render :show, status: :ok, location: @word_net }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @word_net.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /word_nets/1 or /word_nets/1.json
  def destroy
    @word_net.destroy

    respond_to do |format|
      format.html { redirect_to word_nets_url, notice: "Word net was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_word_net
    @word_net = WordNet.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def word_net_params
    params.require(:word_net).permit(:keyword)
  end

  def search_onelook(seleted_word, prefix)
    url = "https://api.onelook.com/words?ml=#{prefix}%20#{seleted_word}&qe=ml&md=dpfcy&max=500&rif=1&csm=100&k=olthes_r4"
    uri = URI(url)
    res = Net::HTTP.get_response(uri)
    return JSON.parse(res.body)
  end
end
