module Fog
  class Vcloud
    module Terremark
      class Ecloud

        class Real
          basic_request :get_catalog_item
        end

        class Mock

          #
          # Based on
          # http://support.theenterprisecloud.com/kb/default.asp?id=542&Lang=1&SID=
          #

          def get_catalog_item(catalog_item_uri)
            if catalog_item_and_vdc = catalog_item_and_vdc_from_catalog_item_uri(catalog_item_uri)
              catalog_item, vdc = catalog_item_and_vdc
              builder = Builder::XmlMarkup.new

              xml = builder.CatalogItem(xmlns.merge(:href => catalog_item_uri, :name => catalog_item[:name])) do
                builder.Link(
                             :rel => "down",
                             :href => Fog::Vcloud::Terremark::Ecloud::Mock.catalog_item_customization_href(:id => catalog_item[:id]),
                             :type => "application/vnd.tmrk.ecloud.catalogItemCustomizationParameters+xml",
                             :name => "Customization Options"
                             )

                builder.Entity(
                               :href => Fog::Vcloud::Terremark::Ecloud::Mock.vapp_template_href(:id => catalog_item[:id]),
                               :type => "application/vnd.vmware.vcloud.vAppTemplate+xml",
                               :name => catalog_item[:name]
                               )

                builder.Property(0, :key => "LicensingCost")
              end
            end

            if xml
              mock_it 200, xml, {'Content-Type' => 'application/vnd.vmware.vcloud.catalogItem+xml'}
            else
              mock_error 200, "401 Unauthorized"
            end
          end
        end
      end
    end
  end
end
