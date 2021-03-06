# -*- encoding : utf-8 -*-
# note that while this is mostly restful routing, the #update and #destroy actions
# take the Solr document ID as the :id, NOT the id of the actual Bookmark action.
class BookmarksController < CatalogController

  ##
  # Give Bookmarks access to the CatalogController configuration
  include Blacklight::Configurable
  include Blacklight::SolrHelper

  copy_blacklight_config_from(CatalogController)
  @bookmarks = ""
  # Blacklight uses #search_action_url to figure out the right URL for
  # the global search box
  def search_action_url
    catalog_index_url
  end
  helper_method :search_action_url

  before_filter :verify_user

  def index
    @bookmarks = current_or_guest_user.bookmarks
    bookmark_ids = @bookmarks.collect { |b| b.document_id.to_s }

    @response, @document_list = get_solr_response_for_field_values(SolrDocument.unique_key, bookmark_ids)
    params[:view] = "index"
    params[:controller] = "bookmarks"
  end

  def update
    create
  end

  def show
 #   setup_next_and_previous_bookmarks
#     @bookmarks = current_or_guest_user.bookmarks
#    bookmark_ids = @bookmarks.collect { |b| b.document_id.to_s }
    bookmarks_id_ordered = []
    @bookmarks = current_or_guest_user.bookmarks
    bookmark_ids = @bookmarks.collect { |b| b.document_id.to_s }
    @response, @document_list = get_solr_response_for_field_values(SolrDocument.unique_key, bookmark_ids)
    for i in 0..@document_list.count - 1
      bookmarks_id_ordered[i] = @document_list[i].id
    end
    @response, @document = get_solr_response_for_doc_id

    counter = bookmarks_id_ordered.index(params[:id])
    if counter.nil?
      counter = 0
    end
    params[:counter] = counter
    params['counter'] = counter
    params[:view] = "bookmarks"
    session[:search][:counter] = counter + 1
    session[:search]['counter'] = counter + 1
    setup_next_and_previous_bookmarks(bookmarks_id_ordered, counter)

  end

  # For adding a single bookmark, suggest use PUT/#update to
  # /bookmarks/$docuemnt_id instead.
  # But this method, accessed via POST to /bookmarks, can be used for
  # creating multiple bookmarks at once, by posting with keys
  # such as bookmarks[n][document_id], bookmarks[n][title].
  # It can also be used for creating a single bookmark by including keys
  # bookmark[title] and bookmark[document_id], but in that case #update
  # is simpler.
  def create
    num_rows = 0
    if params[:num_rows]
      num_rows = params[:num_rows].to_i
      if params[:doc_ids]
        if params[:doc_ids].length < num_rows
          num_rows = params[:doc_ids].length
        end
        @bookmarks = ""
        for i in 0..num_rows - 1
#         @bookmarks = {"document_id" => params[:doc_ids][i].to_i}
         @bookmarks = [{:document_id => params[:doc_ids][i], :document_type => blacklight_config.solr_document_model.to_s }]
         current_or_guest_user.save! unless current_or_guest_user.persisted?

         success = @bookmarks.each do |bookmark|
          current_or_guest_user.bookmarks.create(bookmark) unless current_or_guest_user.existing_bookmark_for(bookmark[:document_id])
         end
        end

        if request.xhr?
          Rails.logger.debug("es287_debug file:#{__FILE__}:#{__LINE__} count = #{current_or_guest_user.bookmarks.count}")
          success ? render(json: { bookmarks: { count: current_or_guest_user.bookmarks.count }}) : render(:text => "", :status => "500")
        else
          if @bookmarks.length > 0 && success
            flash[:notice] = I18n.t('blacklight.bookmarks.add.success', :count => @bookmarks.length)
          elsif @bookmarks.length > 0
            flash[:error] = I18n.t('blacklight.bookmarks.add.failure', :count => @bookmarks.length)
          end
          params.delete :num_rows
          params.delete :doc_ids
          redirect_to :back
        end
      end
    else
      if params[:bookmarks]
        @bookmarks =  params[:bookmarks]
      elsif params[:doc_ids] or !params[:bookmarks]
        @bookmarks = [{ :document_id => params[:id],:document_type => blacklight_config.solr_document_model.to_s }]
      end

      current_or_guest_user.save! unless current_or_guest_user.persisted?

      success = @bookmarks.each do |bookmark|
#        if (!current_or_guest_user.existing_bookmark_for(bookmark[:document_id]))
#        if (!current_or_guest_user.existing_bookmark_for(params[:id]))
          bm = current_or_guest_user.bookmarks.new
          bm.assign_attributes(bookmark,:document_type => blacklight_config.solr_document_model.to_s, :without_protection => true)
          bm.save
#        end
      end

      if request.xhr?
        Rails.logger.debug("es287_debug file: #{__FILE__}:#{__LINE__}# #{__method__} count = #{current_or_guest_user.bookmarks.count}")
        success ? render(json: { bookmarks: { count: current_or_guest_user.bookmarks.count }}) : render(:text => "", :status => "500")
      else
        if @bookmarks.length > 0 && success
          flash[:notice] = I18n.t('blacklight.bookmarks.add.success', :count => @bookmarks.length)
        elsif @bookmarks.length > 0
          flash[:error] = I18n.t('blacklight.bookmarks.add.failure', :count => @bookmarks.length)
        end

        redirect_to :back
      end
    end
  end

  # Beware, :id is the Solr document_id, not the actual Bookmark id.
  # idempotent, as DELETE is supposed to be.
  def destroy

    num_rows = 0
    if params[:num_rows]
      num_rows = params[:num_rows].to_i
      if params[:doc_ids]
        if params[:doc_ids].length < num_rows
          num_rows = params[:doc_ids].length
        end
        @bookmarks = ""
        for i in 0..num_rows - 1
          bookmark = current_or_guest_user.bookmarks.where(document_id: params[:doc_ids][i], document_type: blacklight_config.solr_document_model).first

#          bookmark = current_or_guest_user.existing_bookmark_for(params[:doc_ids][i])
          success = (!bookmark) || current_or_guest_user.bookmarks.delete(bookmark)

          unless request.xhr?
            if success
              flash[:notice] =  I18n.t('blacklight.bookmarks.remove.success')
            else
              flash[:error] = I18n.t('blacklight.bookmarks.remove.failure')
            end
            redirect_to :back
          else
            # ajaxy request needs no redirect and should not have flash set
            success ? render(json: { bookmarks: { count: current_or_guest_user.bookmarks.count }}) : render(:text => "", :status => "500")
          end
        end
       end
    else
       bookmark = current_or_guest_user.bookmarks.where(document_id: params[:id], document_type: blacklight_config.solr_document_model).first
       #bookmark = current_or_guest_user.existing_bookmark_for(params[:id])

        success = (!bookmark) || current_or_guest_user.bookmarks.delete(bookmark)

        unless request.xhr?
          if success
            flash[:notice] =  I18n.t('blacklight.bookmarks.remove.success')
          else
            flash[:error] = I18n.t('blacklight.bookmarks.remove.failure')
          end
          redirect_to :back
        else
          # ajaxy request needs no redirect and should not have flash set
          success ?  render(json: { bookmarks: { count: current_or_guest_user.bookmarks.count }}) : render(:text => "", :status => "500")
        end
    end
  end

  def clear
    if current_or_guest_user.bookmarks.clear
      flash[:notice] = I18n.t('blacklight.bookmarks.clear.success')
    else
      flash[:error] = I18n.t('blacklight.bookmarks.clear.failure')
    end
    redirect_to :action => "index"
  end

  def all

  end

  protected
  def verify_user
    flash[:notice] = I18n.t('blacklight.bookmarks.need_login') and raise Blacklight::Exceptions::AccessDenied  unless current_or_guest_user
  end

      def setup_next_and_previous_bookmarks(bookmarks_id_ordered, counter)
       setup_previous_bookmark(bookmarks_id_ordered, counter)
       setup_next_bookmark(bookmarks_id_ordered, counter)
    end

    # gets a document based on its position within a resultset
    def setup_bookmark_by_counter(bookmarks_id_ordered, counter)
      return if counter < 0 # || bookmarks_id_ordered.blank?
#      get_single_doc_via_search(counter, search)
      new_id = bookmarks_id_ordered[counter]
      @response, @bookmark = get_solr_response_for_doc_id(new_id, {})
     return @bookmark
    end

    def setup_previous_bookmark(bookmarks_id_ordered, counter)
      @previous_bookmark = setup_bookmark_by_counter(bookmarks_id_ordered, counter - 1) # : nil
    end

    def setup_next_bookmark(bookmarks_id_ordered, counter)
      if counter < bookmarks_id_ordered.count - 1
        @next_bookmark = setup_bookmark_by_counter(bookmarks_id_ordered, counter + 1) # : nil
      else
        @next_bookmark = nil
      end
    end

    # sets up the session[:search] hash if it doesn't already exist
#    def search_session
#      session[:search] ||= {}
#    end

end
