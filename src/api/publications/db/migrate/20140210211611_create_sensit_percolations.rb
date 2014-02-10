class CreateSensitPercolations < ActiveRecord::Migration
  def change
    create_table :sensit_percolations do |t|
      t.integer :publication_id
      t.integer :rule_id

      t.timestamps
    end

    add_foreign_key "sensit_percolations", "sensit_topic_publications", name: "sensit_topic_publications_publication_id_fk", column: "publication_id"
	add_foreign_key "sensit_percolations", "sensit_rules", name: "sensit_percolations_rule_id_fk", column: "rule_id"    
	
  end
end
