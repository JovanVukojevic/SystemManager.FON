export interface RadnoMestoRequest {
  naziv: string;
}

export interface RadnoMestoResponse {
  radnoMestoId: number;
  naziv: string;
}

export interface SluzbaRequest {
  naziv: string;
}

export interface SluzbaResponse {
  sluzbaId: number;
  naziv: string;
}

export interface RadnikNaProjekatuRequest {
  radnikId: number;
  datumOd: string;
  datumDo?: string;
}

export interface ProjekatRequest {
  naziv: string;
  budzet: number;
  rukovodiRadnikId?: number;
  radnici: RadnikNaProjekatuRequest[];
}

export interface ProjekatResponse {
  projekatId: number;
  naziv: string;
  budzet: number;
  klasa: number;
  rukovodiRadnikId?: number;
  radnici: RadnikNaProjekatuDto[];
}

export interface RadnikNaProjekatuDto {
  radnikId: number;
  datumOd: string;
  datumDo?: string;
}

export interface ProjekatZaRadnikaRequest {
  projekatId: number;
  datumOd: string;
  datumDo?: string;
}

export interface RadnikRequest {
  ime: string;
  radnoMestoId: number;
  sluzbaId: number;
  projekti: ProjekatZaRadnikaRequest[];
}

export interface RadnikResponse {
  radnikId: number;
  ime: string;
  radnoMesto: RadnoMestoResponse;
  sluzba: SluzbaResponse;
  projekti: ProjekatZaRadnikaDto[];
  isplate: IsplataResponse[];
}

export interface ProjekatZaRadnikaDto {
  projekatId: number;
  datumOd: string;
  datumDo?: string;
}

export interface IsplataRequest {
  vrsta: string;
  datum: string;
  iznos: number;
}

export interface IsplataResponse {
  isplataId: number;
  radnikId: number;
  vrsta: string;
  datum: string;
  iznos: number;
}
