#-- encoding: UTF-8



TypedDag::Configuration.set node_class_name: 'WorkPackage',
                            edge_class_name: 'Relation',
                            ancestor_column: 'from_id',
                            descendant_column: 'to_id',
                            types: {
                              hierarchy: { from: { name: :parent, limit: 1 },
                                           to: :children,
                                           all_from: :ancestors,
                                           all_to: :descendants },
                              relates: { from: :related_to,
                                         to: :relates_to,
                                         all_from: :all_related_to,
                                         all_to: :all_relates_to },
                              duplicates: { from: :duplicates,
                                            to: :duplicated,
                                            all_from: :all_duplicates,
                                            all_to: :all_duplicated },
                              follows: { from: :precedes,
                                         to: :follows,
                                         all_from: :all_precedes,
                                         all_to: :all_follows },
                              blocks: { from: :blocked_by,
                                        to: :blocks,
                                        all_from: :all_blocked_by,
                                        all_to: :all_blocks },
                              includes: { from: :part_of,
                                          to: :includes,
                                          all_from: :all_part_of,
                                          all_to: :all_includes },
                              requires: { from: :required_by,
                                          to: :requires,
                                          all_from: :all_required_by,
                                          all_to: :all_requires }
                            }
