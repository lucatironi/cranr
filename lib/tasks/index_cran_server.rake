# frozen_string_literal: true

task index_cran_server: :environment do
  PackagesIndexerJob.perform_later
end
