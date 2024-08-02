# frozen_string_literal: true

class MediaConvertService < ActiveInteraction::Base # rubocop:disable Metrics/ClassLength
  object :medium

  def execute
    transcoder = Aws::MediaConvert::Client.new(endpoint: ENV['AWS_TRANSCODE_URL'])
    transcoder.create_job(compose_request)
  end

  private

  def compose_request
    medium.audio? ? audio_params : video_params
  end

  def audio_params # rubocop:disable Metrics/MethodLength
    {
      queue: ENV['AWS_TRANSCODE_QUEUE'],
      user_metadata: {},
      role: ENV['AWS_TRANSCODE_ROLE'],
      settings: {
        timecode_config: {
          source: 'ZEROBASED'
        },
        output_groups: [
          {
            name: 'File Group',
            output_group_settings: {
              type: 'FILE_GROUP_SETTINGS',
              file_group_settings: {
                destination: destination_bucket,
                destination_settings: {
                  s3_settings: {
                    access_control: {
                      canned_acl: 'PUBLIC_READ'
                    }
                  }
                }
              }
            },
            outputs: [
              {
                audio_descriptions: [
                  {
                    codec_settings: {
                      codec: 'MP3',
                      mp_3_settings: {
                        rate_control_mode: 'CBR',
                        bitrate: '120000',
                        channels: '2'
                      }
                    },
                    audio_source_name: 'Audio Selector 1'
                  }
                ],
                container_settings: {
                  container: 'RAW'
                }
              }
            ]
          }
        ],
        inputs: [
          {
            audio_selectors: {
              'Audio Selector 1': {
                default_selection: 'DEFAULT'
              }
            },
            video_selector: {},
            timecode_source: 'ZEROBASED',
            file_input: s3_path(medium.attachment.key)
          }
        ]
      },
      acceleration_settings: {
        mode: 'DISABLED'
      },
      status_update_interval: 'SECONDS_10',
      priority: 1
    }
  end

  def video_params # rubocop:disable Metrics/MethodLength
    {
      queue: ENV['AWS_TRANSCODE_QUEUE'],
      user_metadata: {},
      role: ENV['AWS_TRANSCODE_ROLE'],
      settings: {
        timecode_config: {
          source: 'ZEROBASED'
        },
        output_groups: [
          {
            name: 'File Group',
            outputs: [
              {
                preset: 'System-Generic_Hd_Mp4_Avc_Aac_16x9_1280x720p_50Hz_6.0Mbps'
              }
            ],
            output_group_settings: {
              type: 'FILE_GROUP_SETTINGS',
              file_group_settings: {
                destination: destination_bucket,
                destination_settings: {
                  s3_settings: {
                    access_control: {
                      canned_acl: 'PUBLIC_READ'
                    }
                  }
                }
              }
            }
          },
          {
            name: 'File Group',
            outputs: [
              {
                container_settings: {
                  container: 'RAW'
                },
                video_description: {
                  codec_settings: {
                    codec: 'FRAME_CAPTURE',
                    frame_capture_settings: {
                      framerate_numerator: 30,
                      framerate_denominator: 10,
                      max_captures: 2,
                      quality: 80
                    }
                  }
                }
              }
            ],
            output_group_settings: {
              type: 'FILE_GROUP_SETTINGS',
              file_group_settings: {
                destination: destination_bucket,
                destination_settings: {
                  s3_settings: {
                    access_control: {
                      canned_acl: 'PUBLIC_READ'
                    }
                  }
                }
              }
            }
          }
        ],
        inputs: [
          {
            audio_selectors: {
              'Audio Selector 1': {
                default_selection: 'DEFAULT'
              }
            },
            video_selector: { rotate: 'AUTO' },
            timecode_source: 'ZEROBASED',
            file_input: s3_path(medium.attachment.key)
          }
        ]
      },
      acceleration_settings: {
        mode: 'DISABLED'
      },
      status_update_interval: 'SECONDS_10',
      priority: 1
    }
  end

  def s3_path(path)
    "s3://#{ENV['AWS_BUCKET']}/#{path}"
  end

  def destination_bucket
    "s3://#{ENV['AWS_PUBLIC_BUCKET']}/"
  end
end