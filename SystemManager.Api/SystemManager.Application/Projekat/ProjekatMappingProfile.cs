using AutoMapper;
using SystemManager.Application.Projekat;
using SystemManager.Domain.Projekat.Entities;
using DomainProjekt = SystemManager.Domain.Projekat.Entities.Projekat;

namespace SystemManager.Application.Projekat;

public class ProjekatMappingProfile : Profile
{
    public ProjekatMappingProfile()
    {
        CreateMap<RadnoMestoRequest, RadnoMesto>().ReverseMap();
        CreateMap<RadnoMesto, RadnoMestoResponse>();
        CreateMap<SluzbaRequest, Sluzba>().ReverseMap();
        CreateMap<Sluzba, SluzbaResponse>();
        CreateMap<IsplataRequest, Isplata>().ReverseMap();

        CreateMap<Isplata, IsplataResponse>();

        CreateMap<RadnikRequest, Radnik>()
            .ForMember(dest => dest.Projekti, opt => opt.Ignore());
        CreateMap<Radnik, RadnikResponse>()
            .ForMember(dest => dest.RadnoMesto, opt => opt.MapFrom(src => src.RadnoMesto))
            .ForMember(dest => dest.Sluzba, opt => opt.MapFrom(src => src.Sluzba))
            .ForMember(dest => dest.Projekti, opt => opt.MapFrom(src => src.Projekti))
            .ForMember(dest => dest.Isplate, opt => opt.MapFrom(src => src.Isplate));

        CreateMap<RadnikProjekatRequest, Ucestvuje>().ReverseMap();
        CreateMap<Ucestvuje, RadnikProjekatDto>()
            .ForMember(dest => dest.ProjekatNaziv, opt => opt.MapFrom(src =>
                src.Projekat != null ? src.Projekat.Naziv : string.Empty));

        CreateMap<ProjekatRequest, DomainProjekt>()
            .ForMember(dest => dest.Klasa, opt => opt.Ignore())
            .ForMember(dest => dest.Radnici, opt => opt.Ignore());
        CreateMap<DomainProjekt, ProjekatResponse>()
            .ForMember(dest => dest.Radnici, opt => opt.MapFrom(src => src.Radnici));

        CreateMap<ProjekatRadnikRequest, Ucestvuje>().ReverseMap();
        CreateMap<Ucestvuje, ProjekatRadnikDto>()
            .ForMember(dest => dest.RadnikIme, opt => opt.MapFrom(src =>
                src.Radnik != null ? src.Radnik.Ime : string.Empty));
    }
}
