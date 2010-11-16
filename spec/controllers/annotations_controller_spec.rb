require 'spec_helper'

describe AnnotationsController do

  def mock_annotation(stubs={})
    @mock_annotation ||= mock_model(Annotation, stubs)
  end

  describe "GET index" do
    it "assigns all annotations as @annotations" do
      Annotation.stub(:find).with(:all).and_return([mock_annotation])
      get :index
      assigns[:annotations].should == [mock_annotation]
    end
  end

  describe "GET show" do
    it "assigns the requested annotation as @annotation" do
      Annotation.stub(:find).with("37").and_return(mock_annotation)
      get :show, :id => "37"
      assigns[:annotation].should equal(mock_annotation)
    end
  end

  describe "GET new" do
    it "assigns a new annotation as @annotation" do
      Annotation.stub(:new).and_return(mock_annotation)
      get :new
      assigns[:annotation].should equal(mock_annotation)
    end
  end

  describe "GET edit" do
    it "assigns the requested annotation as @annotation" do
      Annotation.stub(:find).with("37").and_return(mock_annotation)
      get :edit, :id => "37"
      assigns[:annotation].should equal(mock_annotation)
    end
  end

  describe "POST create" do

    describe "with valid params" do
      it "assigns a newly created annotation as @annotation" do
        Annotation.stub(:new).with({'these' => 'params'}).and_return(mock_annotation(:save => true))
        post :create, :annotation => {:these => 'params'}
        assigns[:annotation].should equal(mock_annotation)
      end

      it "redirects to the created annotation" do
        Annotation.stub(:new).and_return(mock_annotation(:save => true))
        post :create, :annotation => {}
        response.should redirect_to(annotation_url(mock_annotation))
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved annotation as @annotation" do
        Annotation.stub(:new).with({'these' => 'params'}).and_return(mock_annotation(:save => false))
        post :create, :annotation => {:these => 'params'}
        assigns[:annotation].should equal(mock_annotation)
      end

      it "re-renders the 'new' template" do
        Annotation.stub(:new).and_return(mock_annotation(:save => false))
        post :create, :annotation => {}
        response.should render_template('new')
      end
    end

  end

  describe "PUT update" do

    describe "with valid params" do
      it "updates the requested annotation" do
        Annotation.should_receive(:find).with("37").and_return(mock_annotation)
        mock_annotation.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :annotation => {:these => 'params'}
      end

      it "assigns the requested annotation as @annotation" do
        Annotation.stub(:find).and_return(mock_annotation(:update_attributes => true))
        put :update, :id => "1"
        assigns[:annotation].should equal(mock_annotation)
      end

      it "redirects to the annotation" do
        Annotation.stub(:find).and_return(mock_annotation(:update_attributes => true))
        put :update, :id => "1"
        response.should redirect_to(annotation_url(mock_annotation))
      end
    end

    describe "with invalid params" do
      it "updates the requested annotation" do
        Annotation.should_receive(:find).with("37").and_return(mock_annotation)
        mock_annotation.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :annotation => {:these => 'params'}
      end

      it "assigns the annotation as @annotation" do
        Annotation.stub(:find).and_return(mock_annotation(:update_attributes => false))
        put :update, :id => "1"
        assigns[:annotation].should equal(mock_annotation)
      end

      it "re-renders the 'edit' template" do
        Annotation.stub(:find).and_return(mock_annotation(:update_attributes => false))
        put :update, :id => "1"
        response.should render_template('edit')
      end
    end

  end

  describe "DELETE destroy" do
    it "destroys the requested annotation" do
      Annotation.should_receive(:find).with("37").and_return(mock_annotation)
      mock_annotation.should_receive(:destroy)
      delete :destroy, :id => "37"
    end

    it "redirects to the annotations list" do
      Annotation.stub(:find).and_return(mock_annotation(:destroy => true))
      delete :destroy, :id => "1"
      response.should redirect_to(annotations_url)
    end
  end

end
