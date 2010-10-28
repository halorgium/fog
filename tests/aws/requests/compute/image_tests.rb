Shindo.tests('AWS::Compute | image requests', ['aws']) do

  @images_format = {
    'imagesSet'    => [{
      'architecture'    => String,
      'blockDeviceMapping' =>[],
      'imageId'         => String,
      'imageLocation'   => String,
      'imageOwnerId'    => String,
      'imageState'      => String,
      'imageType'       => String,
      'isPublic'        => Fog::Boolean,
      'kernelId'        => String,
      'productCodes'    => [],
      'ramdiskId'       => String,
      'rootDeviceType'  => String,
      'tagSet'          => {}
    }],
      'requestId'     => String,
  }

  tests('success') do

    # the result for this is HUGE and relatively uninteresting...
    # tests("#describe_images").formats(@images_format) do
    #   AWS[:compute].describe_images.body
    # end

    tests("#describe_images('ImageId' => '#{GENTOO_AMI}')").formats(@images_format) do
      pending if Fog.mocking?
      AWS[:compute].describe_images('ImageId' => GENTOO_AMI).body
    end

    tests("#modify_image_attributes(#{GENTOO_AMI}')").formats({'requestId' => String, "return" => Fog::Boolean}) do
      pending unless Fog.mocking?
      AWS[:compute].modify_image_attributes(GENTOO_AMI, 'launchPermission', 'add', 'UserId' => "1234561234").body
    end

  end

end
