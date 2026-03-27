using AutoMapper;
using SystemManager.Application.Ispit;
using SystemManager.Domain.Ispit.Entities;
using Entities = SystemManager.Domain.Ispit.Entities;

namespace SystemManager.Application.Ispit;

public class IspitMappingProfile : Profile
{
    public IspitMappingProfile()
    {
        CreateMap<StudentRequest, Student>()
            .ForMember(dest => dest.Starost, opt => opt.Ignore());
        CreateMap<Student, StudentResponse>();

        CreateMap<PredmetRequest, Predmet>().ReverseMap();
        CreateMap<Predmet, PredmetResponse>()
            .ForMember(dest => dest.ESPB, opt => opt.MapFrom(src => src.ESPB ?? 0));

        CreateMap<ZvanjeRequest, Zvanje>().ReverseMap();
        CreateMap<Zvanje, ZvanjeResponse>();

        CreateMap<NastavnikRequest, Nastavnik>().ReverseMap();
        CreateMap<IspitRequest, Entities.Ispit>().ReverseMap();

        CreateMap<Nastavnik, NastavnikResponse>()
            .ForMember(dest => dest.Zvanje, opt => opt.MapFrom(src => src.Zvanje));

        CreateMap<Entities.Ispit, IspitResponse>()
            .ForMember(dest => dest.Student, opt => opt.MapFrom(src => src.Student))
            .ForMember(dest => dest.Predmet, opt => opt.MapFrom(src => src.Predmet))
            .ForMember(dest => dest.Nastavnik, opt => opt.MapFrom(src => src.Nastavnik));
    }
}
