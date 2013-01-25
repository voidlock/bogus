module Bogus
  class Injector
    include Dependor::AutoInject
    look_in_modules Bogus

    def configuration
      @configuration ||= inject(Configuration)
    end

    def fake_configuration
      @fake_configuration ||= inject(FakeConfiguration)
    end

    def search_modules
      configuration.search_modules
    end

    def rr_proxy
      Bogus::RRProxy
    end

    def rr_shadow(object)
      inject(Bogus::RRShadow, object: object)
    end

    def fake_registry
      @fake_registry ||= inject(FakeRegistry)
    end

    def creates_fakes
      creates_fakes = inject(CreatesFakes)
      inject(RegistersCreatedFakes, creates_fakes: creates_fakes)
    end

    def create_double(object)
      inject(Double, object: object)
    end

    def create_stub(object)
      create_double(object).stub
    end

    def create_mock(object)
      create_double(object).mock
    end

    def have_received_matcher
      inject(HaveReceivedMatcher)
    end

    def interactions_repository
      raise "Specify either real_interactions or stubbed_interactions"
    end

    def double_tracker
      @double_tracker ||= inject(TracksExistenceOfTestDoubles)
    end

    def clear_tracked_doubles
      @double_tracker = nil
    end

    def real_interactions
      @real_interactions ||= inject(InteractionsRepository)
    end

    def doubled_interactions
      @doubled_interactions ||= inject(InteractionsRepository)
    end

    def create_proxy_class(fake_name, klass)
      inject(ProxyClass, fake_name: fake_name, klass: klass)
    end

    def create_recording_proxy(instance, fake_name)
      inject(RecordingProxy,
        instance: instance,
        fake_name: fake_name,
        interactions_repository: real_interactions)
    end
  end
end
